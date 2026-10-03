extends Node
## Top-level flow: scene navigation, quitting, and the Android back button.

const MAIN_MENU_SCENE := "res://scenes/main_menu.tscn"
const TEST_WORLD_SCENE := "res://scenes/test_world.tscn"


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		_handle_back()


func start_game() -> void:
	get_tree().change_scene_to_file(TEST_WORLD_SCENE)


func goto_main_menu() -> void:
	GameInput.gameplay_active = false
	get_tree().change_scene_to_file(MAIN_MENU_SCENE)


## iOS and web builds must not offer an in-app quit.
func can_quit() -> bool:
	return not (OS.has_feature("ios") or OS.has_feature("web"))


func quit() -> void:
	get_tree().quit()


## Scenes may implement `handle_back() -> bool` to consume the back press
## (e.g. to close a sub-panel) before the default navigation runs.
func _handle_back() -> void:
	var scene := get_tree().current_scene
	if scene == null:
		return
	if scene.has_method(&"handle_back") and scene.handle_back():
		return
	if scene.scene_file_path == MAIN_MENU_SCENE:
		quit()
	else:
		goto_main_menu()
