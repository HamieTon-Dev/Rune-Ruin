class_name TouchJoystick
extends Control
## Floating on-screen joystick. Touching anywhere inside this control places
## the stick under the finger; the resulting vector is pushed to GameInput.

@export var radius := 95.0
@export var knob_radius := 42.0
@export_range(0.0, 0.9) var deadzone := 0.12
@export var rest_margin := Vector2(60.0, 60.0)
@export var base_color := Color(1, 1, 1, 0.18)
@export var ring_color := Color(1, 1, 1, 0.45)
@export var knob_color := Color(1, 1, 1, 0.65)
@export var idle_alpha := 0.55

var output := Vector2.ZERO

var _touch_index := -1
var _center := Vector2.ZERO
var _knob_offset := Vector2.ZERO


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	resized.connect(_on_resized)
	visibility_changed.connect(reset)
	_on_resized()


func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_FOCUS_OUT or what == NOTIFICATION_EXIT_TREE:
		reset()


func _gui_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		var touch := event as InputEventScreenTouch
		if touch.pressed and _touch_index == -1:
			_touch_index = touch.index
			_center = _clamp_center(touch.position)
			_update_knob(touch.position)
			accept_event()
		elif not touch.pressed and touch.index == _touch_index:
			reset()
			accept_event()
	elif event is InputEventScreenDrag:
		var drag := event as InputEventScreenDrag
		if drag.index == _touch_index:
			_update_knob(drag.position)
			accept_event()


func is_active() -> bool:
	return _touch_index != -1


func reset() -> void:
	_touch_index = -1
	_knob_offset = Vector2.ZERO
	_center = _rest_center()
	_set_output(Vector2.ZERO)
	queue_redraw()


func _draw() -> void:
	var alpha := 1.0 if is_active() else idle_alpha
	draw_circle(_center, radius, _with_alpha(base_color, alpha))
	draw_arc(_center, radius, 0.0, TAU, 48, _with_alpha(ring_color, alpha), 3.0, true)
	draw_circle(_center + _knob_offset, knob_radius, _with_alpha(knob_color, alpha))


func _update_knob(local_position: Vector2) -> void:
	_knob_offset = (local_position - _center).limit_length(radius)
	var raw := _knob_offset / radius
	var magnitude := raw.length()
	if magnitude < deadzone:
		_set_output(Vector2.ZERO)
	else:
		_set_output(raw.normalized() * inverse_lerp(deadzone, 1.0, magnitude))
	queue_redraw()


func _set_output(value: Vector2) -> void:
	output = value
	GameInput.set_virtual_move(value)


func _rest_center() -> Vector2:
	return Vector2(rest_margin.x + radius, size.y - rest_margin.y - radius)


## Keeps the whole stick on screen when the finger lands near an edge.
func _clamp_center(point: Vector2) -> Vector2:
	return Vector2(
		clampf(point.x, radius, maxf(radius, size.x - radius)),
		clampf(point.y, radius, maxf(radius, size.y - radius)))


func _on_resized() -> void:
	if not is_active():
		_center = _rest_center()
	queue_redraw()


static func _with_alpha(color: Color, alpha: float) -> Color:
	return Color(color, color.a * alpha)
