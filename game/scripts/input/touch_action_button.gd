class_name TouchActionButton
extends Control
## Round multi-touch button that presses a GameInput action. Unlike Button it
## reacts to any finger, so it works while another finger holds the joystick.

@export var action: StringName = &"jump"
@export var label := "JUMP"
@export var fill_color := Color(1, 1, 1, 0.2)
@export var pressed_fill_color := Color(1, 0.8, 0.4, 0.45)
@export var ring_color := Color(1, 1, 1, 0.55)
@export var label_font_size := 24

var _touch_index := -1


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	visibility_changed.connect(reset)


func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_FOCUS_OUT or what == NOTIFICATION_EXIT_TREE:
		reset()


func _has_point(point: Vector2) -> bool:
	return point.distance_to(size * 0.5) <= _radius()


func _gui_input(event: InputEvent) -> void:
	if not event is InputEventScreenTouch:
		return
	var touch := event as InputEventScreenTouch
	if touch.pressed and _touch_index == -1:
		_touch_index = touch.index
		GameInput.press_virtual_action(action)
		queue_redraw()
		accept_event()
	elif not touch.pressed and touch.index == _touch_index:
		reset()
		accept_event()


func is_pressed() -> bool:
	return _touch_index != -1


func reset() -> void:
	if _touch_index != -1:
		GameInput.release_virtual_action(action)
	_touch_index = -1
	queue_redraw()


func _draw() -> void:
	var center := size * 0.5
	var radius := _radius()
	draw_circle(center, radius, pressed_fill_color if is_pressed() else fill_color)
	draw_arc(center, radius, 0.0, TAU, 48, ring_color, 3.0, true)
	var font := get_theme_default_font()
	var text_size := font.get_string_size(label, HORIZONTAL_ALIGNMENT_CENTER, -1, label_font_size)
	var baseline := center + Vector2(-text_size.x * 0.5, font.get_ascent(label_font_size) - text_size.y * 0.5)
	draw_string(font, baseline, label, HORIZONTAL_ALIGNMENT_LEFT, -1, label_font_size, Color(1, 1, 1, 0.9))


func _radius() -> float:
	return minf(size.x, size.y) * 0.5
