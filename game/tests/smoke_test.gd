extends Node
## Milestone 0 end-to-end smoke test.
##
##   Godot --headless --path game res://tests/smoke_test.tscn
##   Godot --path game res://tests/smoke_test.tscn -- --shots-dir=<abs dir>
##
## Exit code 0 = all checks passed.

const FRAME_TIMEOUT := 600

var _failures: PackedStringArray = []
var _checks := 0
var _sections_completed := 0
var _shots_dir := ""


func _ready() -> void:
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with("--shots-dir="):
			_shots_dir = arg.trim_prefix("--shots-dir=")
	_begin.call_deferred()


func _begin() -> void:
	# Detach from current_scene so change_scene_to_file() doesn't free the runner.
	get_tree().current_scene = null
	await _run()
	_report()


## A script error aborts a test coroutine without failing a check, so each
## section must mark itself complete or the run fails.
func _run() -> void:
	var sections: Array[Callable] = [
		_test_main_menu, _test_world_desktop_flow, _test_touch_controls, _test_return_to_menu]
	for section in sections:
		var completed_before := _sections_completed
		await section.call()
		_check(_sections_completed == completed_before + 1, "section %s ran to completion" % section.get_method())


# --- Tests ----------------------------------------------------------------------

func _test_main_menu() -> void:
	get_tree().change_scene_to_file(Game.MAIN_MENU_SCENE)
	var menu: Node = await _wait_for_scene(Game.MAIN_MENU_SCENE)
	_check(menu != null, "main menu loads")
	if menu == null:
		return
	await _frames(5)
	_check(not GameInput.gameplay_active, "gameplay input inactive on menu")

	var play: Button = menu.get_node("%PlayButton")
	var settings: Button = menu.get_node("%SettingsButton")
	var exit: Button = menu.get_node("%ExitButton")
	var settings_panel: Control = menu.get_node("%SettingsPanel")
	_check(play.is_visible_in_tree() and settings.is_visible_in_tree(), "Play and Settings buttons visible")
	_check(exit.visible == Game.can_quit(), "Exit button visibility matches platform")
	_check(play.size.y >= 64.0, "menu buttons are touch-sized (>= 64 px tall)")
	await _shot("01_main_menu")

	settings.pressed.emit()
	await _frames(2)
	_check(settings_panel.visible, "Settings opens placeholder panel")
	await _shot("02_settings")
	_check(menu.handle_back(), "back closes settings panel")
	await _frames(2)
	_check(not settings_panel.visible and play.is_visible_in_tree(), "menu restored after back")

	play.pressed.emit()
	var world: Node = await _wait_for_scene(Game.TEST_WORLD_SCENE)
	_check(world != null, "Play loads the test world")
	_sections_completed += 1


func _test_world_desktop_flow() -> void:
	var player := _player()
	if player == null:
		_check(false, "player exists in test world")
		return
	_check(GameInput.gameplay_active, "gameplay input active in world")

	await _physics_frames(30)
	_check(player.is_on_floor(), "player settles on the ground")
	await _shot("03_world_spawn")

	var start := player.global_position
	GameInput.set_virtual_move(Vector2(0, -1))
	await _physics_frames(40)
	GameInput.set_virtual_move(Vector2.ZERO)
	var moved := player.global_position - start
	_check(moved.z < -1.5 and absf(moved.x) < 0.3, "forward input moves away from camera (dz=%.2f)" % moved.z)

	var rig: ThirdPersonCamera = player.camera_rig
	var yaw_before := rig.yaw
	GameInput.add_touch_look(Vector2(150, 0))
	await _frames(2)
	_check(not is_equal_approx(rig.yaw, yaw_before), "look input orbits camera yaw")

	var pitch_before := rig.pitch
	GameInput.add_touch_look(Vector2(0, -2000))
	await _frames(2)
	_check(rig.pitch <= deg_to_rad(rig.max_pitch_degrees) + 0.001 and rig.pitch > pitch_before, "camera pitch clamped")

	# Camera-relative movement: after turning the camera, forward follows it.
	start = player.global_position
	GameInput.set_virtual_move(Vector2(0, -1))
	await _physics_frames(30)
	GameInput.set_virtual_move(Vector2.ZERO)
	var expected := Vector3.FORWARD.rotated(Vector3.UP, rig.yaw)
	var dir := (player.global_position - start)
	dir.y = 0.0
	_check(dir.normalized().dot(expected) > 0.95, "movement is camera-relative")

	await _physics_frames(20)
	var ground_y := player.global_position.y
	var key_event := InputEventAction.new()
	key_event.action = GameInput.JUMP
	key_event.pressed = true
	Input.parse_input_event(key_event)
	var peak := ground_y
	for i in 30:
		await get_tree().physics_frame
		peak = maxf(peak, player.global_position.y)
	var release := InputEventAction.new()
	release.action = GameInput.JUMP
	release.pressed = false
	Input.parse_input_event(release)
	_check(peak > ground_y + 1.0, "jump action lifts player (peak +%.2f m)" % (peak - ground_y))
	await _physics_frames(90)
	_check(player.is_on_floor(), "player lands after jump")
	await _shot("04_world_after_jump")
	_sections_completed += 1


func _test_touch_controls() -> void:
	var world := get_tree().current_scene
	GameInput.touch_controls_enabled = true
	await _frames(3)
	var touch_layer: CanvasLayer = world.get_node("TouchControls")
	var joystick: TouchJoystick = world.get_node("TouchControls/%TouchJoystick")
	var jump_button: TouchActionButton = world.get_node("TouchControls/%JumpButton")
	_check(touch_layer.visible, "touch controls visible when enabled")
	_check(Input.mouse_mode != Input.MOUSE_MODE_CAPTURED, "mouse not captured in touch mode")

	# Joystick: finger 0 down in the left zone, drag up.
	var stick_origin := joystick.get_global_rect().get_center()
	_touch(0, stick_origin, true)
	await _frames(1)
	_drag(0, stick_origin + Vector2(0, -80), Vector2(0, -80))
	await _wait_until(func() -> bool: return GameInput.get_move_vector().y < -0.5)
	var move := GameInput.get_move_vector()
	_check(joystick.is_active() and move.y < -0.5, "joystick drag produces forward move (%.2f)" % move.y)

	# Look: finger 1 drags on the right half while the stick is held.
	var rig: ThirdPersonCamera = _player().camera_rig
	var yaw_before := rig.yaw
	var look_origin := Vector2(get_viewport().get_visible_rect().size.x * 0.65, 200)
	_touch(1, look_origin, true)
	await _frames(1)
	_drag(1, look_origin + Vector2(60, 0), Vector2(60, 0))
	await _wait_until(func() -> bool: return not is_equal_approx(rig.yaw, yaw_before))
	_check(not is_equal_approx(rig.yaw, yaw_before), "touch drag on right side orbits camera")
	_check(GameInput.get_move_vector().y < -0.5, "joystick keeps working during multi-touch look")
	await _shot("05_world_touch")

	# Jump: finger 2 taps the jump button.
	var player := _player()
	_touch(0, stick_origin, false)
	_touch(1, look_origin + Vector2(60, 0), false)
	await _physics_frames(40)
	_check(GameInput.get_move_vector() == Vector2.ZERO, "releasing joystick stops movement")
	var ground_y := player.global_position.y
	var jump_center := jump_button.get_global_rect().get_center()
	_touch(2, jump_center, true)
	await _wait_until(jump_button.is_pressed)
	_check(jump_button.is_pressed(), "jump button registers touch")
	var peak := ground_y
	for i in 30:
		await get_tree().physics_frame
		peak = maxf(peak, player.global_position.y)
	_touch(2, jump_center, false)
	await _wait_until(func() -> bool: return not jump_button.is_pressed())
	_check(peak > ground_y + 1.0, "touch jump lifts player (peak +%.2f m)" % (peak - ground_y))
	_check(not jump_button.is_pressed(), "jump button releases with finger")

	GameInput.touch_controls_enabled = false
	await _frames(2)
	_check(not touch_layer.visible, "touch controls hidden when disabled")
	_sections_completed += 1


func _test_return_to_menu() -> void:
	var hud_button: Button = get_tree().current_scene.get_node("GameHUD/%MenuButton")
	hud_button.pressed.emit()
	var menu: Node = await _wait_for_scene(Game.MAIN_MENU_SCENE)
	_check(menu != null, "HUD Menu button returns to main menu")
	_check(not GameInput.gameplay_active, "gameplay input disabled after leaving world")
	_check(Input.mouse_mode == Input.MOUSE_MODE_VISIBLE, "mouse released on menu")
	_sections_completed += 1


# --- Helpers --------------------------------------------------------------------

func _player() -> PlayerController:
	var scene := get_tree().current_scene
	return scene.get_node_or_null("Player") as PlayerController if scene else null


## Injected events are in window pixels; tests work in canvas units, which only
## coincide at the base 1280x720 resolution.
func _to_window(canvas_position: Vector2) -> Vector2:
	return get_viewport().get_final_transform() * canvas_position


func _touch(index: int, position: Vector2, pressed: bool) -> void:
	var event := InputEventScreenTouch.new()
	event.index = index
	event.position = _to_window(position)
	event.pressed = pressed
	Input.parse_input_event(event)


func _drag(index: int, position: Vector2, relative: Vector2) -> void:
	var event := InputEventScreenDrag.new()
	var window_relative := get_viewport().get_final_transform().basis_xform(relative)
	event.index = index
	event.position = _to_window(position)
	event.relative = window_relative
	event.screen_relative = window_relative
	Input.parse_input_event(event)


func _wait_for_scene(path: String) -> Node:
	for i in FRAME_TIMEOUT:
		await get_tree().process_frame
		var scene := get_tree().current_scene
		if scene and scene.scene_file_path == path and scene.is_node_ready():
			return scene
	return null


## Injected input is delivered on a later frame that varies with load.
func _wait_until(condition: Callable, max_frames := 30) -> void:
	for i in max_frames:
		if condition.call():
			return
		await get_tree().process_frame


func _frames(count: int) -> void:
	for i in count:
		await get_tree().process_frame


func _physics_frames(count: int) -> void:
	for i in count:
		await get_tree().physics_frame


func _shot(shot_name: String) -> void:
	if _shots_dir.is_empty() or DisplayServer.get_name() == "headless":
		return
	await _frames(3)
	await RenderingServer.frame_post_draw
	var image := get_viewport().get_texture().get_image()
	var path := _shots_dir.path_join(shot_name + ".png")
	image.save_png(path)
	print("screenshot: ", path)


func _check(condition: bool, description: String) -> void:
	_checks += 1
	if condition:
		print("  PASS  ", description)
	else:
		print("  FAIL  ", description)
		_failures.append(description)


func _report() -> void:
	print("")
	if _failures.is_empty():
		print("SMOKE TEST PASSED (%d checks)" % _checks)
	else:
		print("SMOKE TEST FAILED: %d of %d checks failed" % [_failures.size(), _checks])
	get_tree().quit(0 if _failures.is_empty() else 1)
