extends Control
## Title screen: Play, Settings (placeholder) and Exit.

@onready var _menu_panel: Control = %MenuPanel
@onready var _settings_panel: Control = %SettingsPanel
@onready var _play_button: Button = %PlayButton
@onready var _settings_button: Button = %SettingsButton
@onready var _exit_button: Button = %ExitButton
@onready var _settings_back_button: Button = %SettingsBackButton
@onready var _version_label: Label = %VersionLabel


func _ready() -> void:
	GameInput.gameplay_active = false
	_play_button.pressed.connect(Game.start_game)
	_settings_button.pressed.connect(_show_settings)
	_settings_back_button.pressed.connect(_show_menu)
	_exit_button.pressed.connect(Game.quit)
	_exit_button.visible = Game.can_quit()
	_version_label.text = "Milestone 0  |  v%s" % ProjectSettings.get_setting("application/config/version")
	_show_menu()


## Called by Game when the Android back button is pressed.
func handle_back() -> bool:
	if _settings_panel.visible:
		_show_menu()
		return true
	return false


func _show_menu() -> void:
	_settings_panel.hide()
	_menu_panel.show()
	_play_button.grab_focus()


func _show_settings() -> void:
	_menu_panel.hide()
	_settings_panel.show()
	_settings_back_button.grab_focus()
