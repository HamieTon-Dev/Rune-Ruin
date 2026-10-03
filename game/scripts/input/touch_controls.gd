extends CanvasLayer
## Shows the on-screen controls only when GameInput has touch controls enabled.

@onready var _resettables: Array = [%LookArea, %TouchJoystick, %JumpButton]


func _ready() -> void:
	GameInput.touch_controls_enabled_changed.connect(_apply_enabled)
	_apply_enabled(GameInput.touch_controls_enabled)


func _apply_enabled(enabled: bool) -> void:
	visible = enabled
	for node in _resettables:
		node.reset()
