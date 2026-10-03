class_name SafeArea
extends Control
## Full-rect container that insets itself to the display's safe area
## (notches, rounded corners, gesture bars) on mobile devices.

## A 180-degree flip under sensor-landscape moves the notch to the other side
## without resizing the viewport, so mobile re-reads the safe area periodically.
const POLL_INTERVAL := 0.5

@export var extra_margin := 0.0

var _last_safe_area := Rect2i()
var _poll_timer := 0.0


func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	get_viewport().size_changed.connect(_update_insets)
	set_process(OS.has_feature("mobile"))
	_update_insets()


func _process(delta: float) -> void:
	_poll_timer += delta
	if _poll_timer < POLL_INTERVAL:
		return
	_poll_timer = 0.0
	if DisplayServer.get_display_safe_area() != _last_safe_area:
		_update_insets()


func _update_insets() -> void:
	_last_safe_area = DisplayServer.get_display_safe_area()
	var insets := _safe_insets()
	offset_left = insets.position.x + extra_margin
	offset_top = insets.position.y + extra_margin
	offset_right = -(insets.size.x + extra_margin)
	offset_bottom = -(insets.size.y + extra_margin)


## Returns left/top in position and right/bottom in size, in canvas units.
func _safe_insets() -> Rect2:
	if not OS.has_feature("mobile"):
		return Rect2()
	var window_size := Vector2(DisplayServer.window_get_size())
	if window_size.x <= 0.0 or window_size.y <= 0.0:
		return Rect2()
	var safe := Rect2(DisplayServer.get_display_safe_area())
	var window_rect := Rect2(Vector2(DisplayServer.window_get_position()), window_size)
	var to_canvas := get_viewport_rect().size / window_size
	var left := maxf(safe.position.x - window_rect.position.x, 0.0)
	var top := maxf(safe.position.y - window_rect.position.y, 0.0)
	var right := maxf(window_rect.end.x - safe.end.x, 0.0)
	var bottom := maxf(window_rect.end.y - safe.end.y, 0.0)
	return Rect2(left * to_canvas.x, top * to_canvas.y, right * to_canvas.x, bottom * to_canvas.y)
