extends CanvasLayer
## In-game overlay: control hints, mouse-capture prompt and the Menu button.

const DESKTOP_HINT := "WASD move  |  Mouse look  |  Space jump  |  Esc free cursor"
const TOUCH_HINT := "Left side: move  |  Right side: look  |  JUMP button"

@onready var _menu_button: Button = %MenuButton
@onready var _hint_label: Label = %HintLabel
@onready var _capture_prompt: Label = %CapturePrompt


func _ready() -> void:
	_menu_button.pressed.connect(Game.goto_main_menu)
	GameInput.touch_controls_enabled_changed.connect(_refresh_hint)
	_refresh_hint(GameInput.touch_controls_enabled)


func _process(_delta: float) -> void:
	_capture_prompt.visible = (
		GameInput.gameplay_active
		and not GameInput.touch_controls_enabled
		and Input.mouse_mode != Input.MOUSE_MODE_CAPTURED)


func _refresh_hint(touch_enabled: bool) -> void:
	_hint_label.text = TOUCH_HINT if touch_enabled else DESKTOP_HINT
