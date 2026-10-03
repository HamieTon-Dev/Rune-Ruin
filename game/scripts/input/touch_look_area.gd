class_name TouchLookArea
extends Control
## Drag anywhere in this control to orbit the camera. Tracks one finger so a
## second finger on another control doesn't fight over the camera.

var _touch_index := -1


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	visibility_changed.connect(reset)


func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_FOCUS_OUT or what == NOTIFICATION_EXIT_TREE:
		reset()


func _gui_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		var touch := event as InputEventScreenTouch
		if touch.pressed and _touch_index == -1:
			_touch_index = touch.index
			accept_event()
		elif not touch.pressed and touch.index == _touch_index:
			reset()
			accept_event()
	elif event is InputEventScreenDrag:
		var drag := event as InputEventScreenDrag
		if drag.index == _touch_index:
			GameInput.add_touch_look(drag.relative)
			accept_event()


func reset() -> void:
	_touch_index = -1
