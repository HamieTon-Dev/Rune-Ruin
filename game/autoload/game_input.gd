extends Node
## Device-agnostic input facade.
##
## Gameplay code reads player *intent* from here (move vector, look delta,
## buffered action presses) and never touches devices directly. Device sources
## write into it: keyboard/mouse and gamepad are read here, and the on-screen
## touch UI (res://ui/touch_controls.tscn) pushes its state through the
## set_virtual_move / add_touch_look / press_virtual_action API.

signal touch_controls_enabled_changed(enabled: bool)

const MOVE_LEFT := &"move_left"
const MOVE_RIGHT := &"move_right"
const MOVE_FORWARD := &"move_forward"
const MOVE_BACK := &"move_back"
const LOOK_LEFT := &"look_left"
const LOOK_RIGHT := &"look_right"
const LOOK_UP := &"look_up"
const LOOK_DOWN := &"look_down"
const JUMP := &"jump"

## Discrete actions whose presses are buffered until gameplay consumes them,
## so a press between physics ticks is never lost.
const BUFFERED_ACTIONS: Array[StringName] = [JUMP]

const CMD_FORCE_TOUCH := "--touch-ui"
const CMD_DISABLE_TOUCH := "--no-touch-ui"

## Radians per screen pixel of mouse motion.
var mouse_sensitivity := 0.0025
## Radians per canvas unit of touch drag (canvas units are resolution-independent).
var touch_look_sensitivity := 0.006
## Radians per second at full right-stick deflection.
var gamepad_look_speed := 3.0
var invert_y := false

var gameplay_active := false: set = set_gameplay_active
var touch_controls_enabled := false: set = set_touch_controls_enabled

var _virtual_move := Vector2.ZERO
var _look_delta := Vector2.ZERO
var _buffered_presses: Dictionary = {}
var _virtual_held: Dictionary = {}


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_register_default_actions()
	touch_controls_enabled = _detect_touch_controls()


func _process(delta: float) -> void:
	if not gameplay_active:
		return
	var stick := Input.get_vector(LOOK_LEFT, LOOK_RIGHT, LOOK_UP, LOOK_DOWN)
	if stick != Vector2.ZERO:
		_add_look_radians(stick * gamepad_look_speed * delta)


func _unhandled_input(event: InputEvent) -> void:
	if not gameplay_active:
		return

	for action in BUFFERED_ACTIONS:
		if event.is_action_pressed(action):
			_buffered_presses[action] = true

	if touch_controls_enabled:
		return

	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		_add_look_radians((event as InputEventMouseMotion).screen_relative * mouse_sensitivity)
	elif event is InputEventMouseButton and event.pressed and Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		capture_mouse()
	elif event.is_action_pressed(&"ui_cancel"):
		release_mouse()


func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_FOCUS_OUT or what == NOTIFICATION_APPLICATION_PAUSED:
		clear_transient_state()


# --- Gameplay-facing API -----------------------------------------------------

## Movement intent in screen space: x = right, y = back (forward is -y). Length <= 1.
func get_move_vector() -> Vector2:
	if not gameplay_active:
		return Vector2.ZERO
	var device := Input.get_vector(MOVE_LEFT, MOVE_RIGHT, MOVE_FORWARD, MOVE_BACK)
	var chosen := device if device.length_squared() >= _virtual_move.length_squared() else _virtual_move
	return chosen.limit_length(1.0)


## Accumulated look rotation in radians since the last call: x = yaw right, y = pitch down.
func consume_look_delta() -> Vector2:
	var delta := _look_delta
	_look_delta = Vector2.ZERO
	return delta


## Returns true once per press of a buffered action, from any device.
func consume_action_press(action: StringName) -> bool:
	return _buffered_presses.erase(action)


func is_action_held(action: StringName) -> bool:
	return gameplay_active and (Input.is_action_pressed(action) or _virtual_held.has(action))


# --- Device-source API (touch UI, future remote/replay sources) ---------------

func set_virtual_move(value: Vector2) -> void:
	_virtual_move = value.limit_length(1.0)


func add_touch_look(canvas_delta: Vector2) -> void:
	_add_look_radians(canvas_delta * touch_look_sensitivity)


func press_virtual_action(action: StringName) -> void:
	if _virtual_held.has(action):
		return
	_virtual_held[action] = true
	if gameplay_active and action in BUFFERED_ACTIONS:
		_buffered_presses[action] = true


func release_virtual_action(action: StringName) -> void:
	_virtual_held.erase(action)


# --- State --------------------------------------------------------------------

func set_gameplay_active(value: bool) -> void:
	gameplay_active = value
	clear_transient_state()
	if value and not touch_controls_enabled:
		capture_mouse()
	elif not value:
		release_mouse()


func set_touch_controls_enabled(value: bool) -> void:
	if touch_controls_enabled == value:
		return
	touch_controls_enabled = value
	clear_transient_state()
	if value:
		release_mouse()
	# Lets desktop testers drive the touch UI with a mouse.
	if not OS.has_feature("mobile"):
		Input.emulate_touch_from_mouse = value
	touch_controls_enabled_changed.emit(value)


func clear_transient_state() -> void:
	_virtual_move = Vector2.ZERO
	_look_delta = Vector2.ZERO
	_buffered_presses.clear()
	_virtual_held.clear()


func capture_mouse() -> void:
	if gameplay_active and not touch_controls_enabled:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func release_mouse() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


# --- Internals ----------------------------------------------------------------

func _add_look_radians(radians: Vector2) -> void:
	if invert_y:
		radians.y = -radians.y
	_look_delta += radians


func _detect_touch_controls() -> bool:
	var args := OS.get_cmdline_user_args()
	if CMD_FORCE_TOUCH in args:
		return true
	if CMD_DISABLE_TOUCH in args:
		return false
	return OS.has_feature("mobile")


## Default bindings are only added for actions the project doesn't already
## define, so bindings edited in Project Settings > Input Map take precedence.
func _register_default_actions() -> void:
	_add_action(MOVE_FORWARD, [_key(KEY_W), _key(KEY_UP), _axis(JOY_AXIS_LEFT_Y, -1.0)])
	_add_action(MOVE_BACK, [_key(KEY_S), _key(KEY_DOWN), _axis(JOY_AXIS_LEFT_Y, 1.0)])
	_add_action(MOVE_LEFT, [_key(KEY_A), _key(KEY_LEFT), _axis(JOY_AXIS_LEFT_X, -1.0)])
	_add_action(MOVE_RIGHT, [_key(KEY_D), _key(KEY_RIGHT), _axis(JOY_AXIS_LEFT_X, 1.0)])
	_add_action(LOOK_LEFT, [_axis(JOY_AXIS_RIGHT_X, -1.0)])
	_add_action(LOOK_RIGHT, [_axis(JOY_AXIS_RIGHT_X, 1.0)])
	_add_action(LOOK_UP, [_axis(JOY_AXIS_RIGHT_Y, -1.0)])
	_add_action(LOOK_DOWN, [_axis(JOY_AXIS_RIGHT_Y, 1.0)])
	_add_action(JUMP, [_key(KEY_SPACE), _button(JOY_BUTTON_A)])


func _add_action(action: StringName, events: Array, deadzone := 0.2) -> void:
	if InputMap.has_action(action):
		return
	InputMap.add_action(action, deadzone)
	for event in events:
		InputMap.action_add_event(action, event)


func _key(physical_keycode: Key) -> InputEventKey:
	var event := InputEventKey.new()
	event.physical_keycode = physical_keycode
	return event


func _axis(axis: JoyAxis, direction: float) -> InputEventJoypadMotion:
	var event := InputEventJoypadMotion.new()
	event.axis = axis
	event.axis_value = direction
	return event


func _button(button: JoyButton) -> InputEventJoypadButton:
	var event := InputEventJoypadButton.new()
	event.button_index = button
	return event
