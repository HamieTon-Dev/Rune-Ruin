# Rune & Ruin Build Status

## Current Milestone

Milestone 0 - Playable Android Prototype

## Current Task

Milestone 0 implementation complete (desktop-verified). Awaiting on-device Android verification.

## Cursor

Primary implementation agent.

## Claude Code

Review, debugging, architecture, and testing.

## Rules

- Read AGENTS.md before modifying anything.
- Read BUILD_STATUS.md before starting work.
- Update BUILD_STATUS.md after completing a task.
- Do not start unrelated features.
- Do not duplicate existing systems.
- Android is primary.
- Windows/Steam must remain supported.
- Server-authoritative MMO architecture is required long-term.

## Completed

- GitHub repository created
- Godot project created
- Cursor installed
- Claude Code installed
- Milestone 0: main menu, 3D test environment, third-person controller, desktop + touch input

---

## Milestone 0 Report (2026-10-03)

### Work completed

1. **Main menu** (`scenes/main_menu.tscn`): title, Play, Settings, Exit, version label.
2. **Play button**: loads `scenes/test_world.tscn` through the `Game` autoload.
3. **Settings placeholder**: in-menu panel with a Back button. The Android back button also closes it.
4. **Exit button**: quits the game. It is hidden on iOS/web, where in-app quit isn't allowed.
5. **3D test environment** (`scenes/test_world.tscn`): 80x80 m grid floor, four stepped jump platforms (0.5 to 2 m), a 20° ramp up to a raised deck, crates, a large block, pillars, and a wall for testing camera collision. Procedural sky, a directional sun with shadows, and a world-space grid shader so scale and motion are easy to read.
6. **Third-person player controller** (`scenes/player/player.tscn`): CharacterBody3D with camera-relative movement and separate ground/air acceleration. Only the model turns to face the movement direction; the body and camera rig stay unrotated. Falling below the kill height respawns the player.
7. **WASD desktop movement**: WASD and arrow keys, bound by physical key so they work on any keyboard layout. Gamepad left stick is also bound (Steam).
8. **Mouse camera orbit**: captured-mouse orbit with pitch clamped to -70°/+35°. A SpringArm3D keeps the camera out of walls. Esc frees the cursor and clicking recaptures it. The right stick orbits too.
9. **Jump**: Space / gamepad A / touch button. Includes coyote time (0.1 s), a jump buffer (0.12 s), and heavier gravity while falling.
10. **Android virtual joystick**: floating multi-touch joystick on the left side of the screen, with deadzone remapping.
11. **Android touch camera**: drag anywhere on the right side to orbit. Tracks one finger independently, so moving and looking work at the same time.
12. **Responsive mobile UI**: 1280x720 base with `canvas_items` + `expand` stretch. Layout is anchor-based, menu buttons are touch-sized (76 px), and a `SafeArea` control insets the UI for notches and cutouts on mobile. Orientation is sensor landscape. Checked at 16:9, 20:9 and 4:3.

### Input architecture

```
Devices                          Facade (autoload)            Gameplay
-------                          -----------------            --------
Keyboard / mouse / gamepad --->  GameInput                --> PlayerController (move, jump)
Touch UI (TouchJoystick,   --->    get_move_vector()      --> ThirdPersonCamera (look)
  TouchLookArea,                   consume_look_delta()
  TouchActionButton)               consume_action_press()
```

- Gameplay scripts never read devices or touch events. They only call `GameInput`.
- Touch controls only write into `GameInput` (`set_virtual_move`, `add_touch_look`, `press/release_virtual_action`).
- Discrete actions (jump) are buffered, so a press between physics ticks is never lost.
- Default bindings are registered at runtime only for actions that aren't already in the Input Map, so bindings edited in Project Settings take precedence.
- Touch UI is on automatically on mobile. On desktop, `-- --touch-ui` forces it on (and turns on touch-from-mouse emulation) and `-- --no-touch-ui` forces it off.
- The Android back button is handled centrally in `Game`: in-game it returns to the menu; on the menu it closes the Settings panel, then quits.

### Files created

- `game/autoload/game_input.gd`: input abstraction facade (autoload `GameInput`)
- `game/autoload/game.gd`: scene flow, quit, Android back button (autoload `Game`)
- `game/scenes/main_menu.tscn`
- `game/scenes/test_world.tscn`
- `game/scenes/player/player.tscn`
- `game/scripts/player/player_controller.gd` (`PlayerController`)
- `game/scripts/camera/third_person_camera.gd` (`ThirdPersonCamera`)
- `game/scripts/input/touch_joystick.gd` (`TouchJoystick`)
- `game/scripts/input/touch_look_area.gd` (`TouchLookArea`)
- `game/scripts/input/touch_action_button.gd` (`TouchActionButton`)
- `game/scripts/input/touch_controls.gd`
- `game/scripts/ui/main_menu.gd`
- `game/scripts/ui/game_hud.gd`
- `game/scripts/ui/safe_area.gd` (`SafeArea`)
- `game/scripts/world/test_world.gd`
- `game/ui/touch_controls.tscn`
- `game/ui/game_hud.tscn`
- `game/ui/theme/main_theme.tres`
- `game/shaders/prototype_grid.gdshader`
- `game/tests/smoke_test.gd`, `game/tests/smoke_test.tscn`: automated end-to-end smoke test
- `*.gd.uid` / `*.gdshader.uid`: generated by Godot on import; commit them

### Files modified

- `game/project.godot`: main scene, version 0.0.1, `quit_on_go_back=false`, autoloads (`GameInput`, `Game`), 1280x720 base size, sensor-landscape orientation, custom theme, physics layer names (1 = world, 2 = player), ETC2/ASTC texture compression (required for Android export).
- `BUILD_STATUS.md`: this report.

### Errors

Found and fixed during the milestone:

- **Class name clash:** `class_name VirtualJoystick` collides with a native class added in Godot 4.7. Renamed it to `TouchJoystick`.
- **Silent smoke-test aborts:** a script error could abort a test section without failing the run. The runner now requires every section to finish.
- **Wrong touch coordinates in the test:** injected touches used canvas coordinates instead of window pixels, which broke off-16:9 runs. Fixed in the test helpers; game code was not affected.
- **Timing-sensitive touch checks:** fixed waits were replaced with polling plus a timeout.

Known limitations, not blocking:

- **Headless mode can't verify touch:** GUI routing of touch/mouse isn't reliable headless, so run the smoke test **windowed** to check touch input properly.
- **No device testing yet:** Android export templates, the Android SDK and an export preset aren't set up on this machine (JDK 21 is installed), so nothing has been run on a phone.
- **Possible camera judder above 60 Hz:** the camera follows the physics body without physics interpolation, so it may judder slightly on displays above 60 Hz. Revisit when tuning game feel.
- **Unused Summer Engine leftovers:** `AGENTS.md`, `CLAUDE.md`, `.mcp.json`, `.claude/`, `.cursor/skills/`, `game/.summer/` and `game/project.godot.bak` remain in the repo. Summer isn't part of the workflow; clean these up when convenient.

### Tests performed

All runs use `D:\Godot_v4.7.2-stable_win64_console.exe`.

| Test | Result |
|---|---|
| Headless import (`--headless --path game --import`) | Clean; no parse errors or warnings |
| Smoke test, windowed 1280x720 | 34/34 PASS |
| Smoke test, windowed 2400x1080 (20:9 phone) | 34/34 PASS |
| Smoke test, windowed 1024x768 (4:3 tablet), repeated | 34/34 PASS |
| Smoke test, headless | 34/34 PASS |
| Normal launch (main scene) and world with `--touch-ui` | No errors in output |
| Visual check of screenshots (menu, settings, world, touch UI at three aspect ratios) | Layout correct |

The smoke test covers:

- Menu: buttons exist and are touch-sized; Settings opens; Back closes it; Play loads the world.
- Movement and camera: the player lands on the floor; forward moves away from the camera; movement follows the camera; look changes yaw; pitch is clamped.
- Jump: the jump action lifts the player more than 1 m, and the player lands again.
- Touch: the joystick drag gives forward movement; a second finger orbits while the joystick is held; releasing stops movement; the touch jump button jumps and releases.
- Cleanup: touch UI hides and shows correctly; the HUD Menu button returns to the menu and releases input and the mouse.

Run it:

```
cd game
D:\Godot_v4.7.2-stable_win64_console.exe --path . res://tests/smoke_test.tscn
D:\Godot_v4.7.2-stable_win64_console.exe --path . res://tests/smoke_test.tscn -- --shots-dir=C:/temp/shots
```

Try touch controls on desktop: `--path . -- --touch-ui` (drive them with the mouse).

## Next

**Recommended next task:** set up the Android export pipeline and verify on a device.

1. Install the Godot 4.7.2 export templates and the Android SDK (platform-tools, build-tools, platform 35). Point Editor Settings at the SDK and JDK 21.
2. Create an Android export preset (arm64-v8a, landscape, Vulkan/Mobile, debug keystore) and commit `export_presets.cfg` without credentials.
3. Deploy to a physical phone and check the joystick and look feel, safe-area insets, the back button, frame rate, and thermal behaviour. Tune `touch_look_sensitivity` and joystick radius from that playtest.
4. Add a Windows export preset at the same time so the Steam target stays continuously buildable.

---

## Milestone 0 Code Review — Claude Code (2026-10-03)

Scope: every script, scene, shader, theme and project setting under `game/`. No gameplay features were added.

### Summary

The implementation is in good shape:

- **Godot 4.7:** the code uses current APIs correctly (`screen_relative`, `Input.get_vector`, physical keycodes, Jolt), and the project imports with no parse errors or warnings.
- **Input abstraction:** clean. Gameplay never reads devices directly, touch controls only write into `GameInput`, and Project Settings bindings take precedence over the runtime defaults.
- **Scene organisation:** player, HUD and touch controls are self-contained scenes that the world instances.
- **Dependencies:** there are no addons, plugins or C# scripts.

One genuine bug was found and fixed.

### Issues found

1. **Bug (Android): stale safe-area insets after a 180° rotation.** The project uses sensor landscape, so turning the phone over moves the notch or cutout to the opposite edge without changing the viewport size. `SafeArea` only recalculated on `size_changed`, so it kept insetting the old edge, and the HUD Menu button and touch controls could sit under the cutout.

Checked and found not to be problems:

- **`ui_cancel` and gamepads:** in 4.7, `ui_cancel` is bound to Escape only (confirmed by probing a clean project), so a gamepad B press does not free the cursor.
- **Click-to-capture on desktop:** the hidden touch layer does not swallow mouse clicks. A temporary probe confirmed that a click in the world captures the mouse.
- **Multi-touch routing and touch mouse emulation:** `emulate_mouse_from_touch` is on by default (as it is on Android), and multi-touch routing still works. The smoke test exercises both together.
- **Duplicated `gameplay_active = false`:** this is set in the menu, in `Game.goto_main_menu` and in the world's `_exit_tree`. It's redundant but harmless and makes each scene safe to open on its own, so it was left alone.
- **Touch-tracking code:** the three touch controls have a similar small touch-index pattern. It isn't worth a shared base class at this size.

### Fixes made

- `game/scripts/ui/safe_area.gd`: on mobile only, re-reads `DisplayServer.get_display_safe_area()` every 0.5 s and re-applies the insets when it changes. The check is cheap and runs only on mobile. Resize-driven updates work as before.

### Files changed

- `game/scripts/ui/safe_area.gd`: the safe-area fix above.
- `CLAUDE.md`: replaced the outdated "empty scaffold" description with the actual architecture and test commands.
- `BUILD_STATUS.md`: this section.

### Tests performed

All runs use `D:\Godot_v4.7.2-stable_win64_console.exe`.

| Test | Result |
|---|---|
| Baseline smoke test before changes, windowed 1280x720 | 34/34 PASS |
| Headless import after the fix | No errors or warnings |
| Smoke test, windowed 1280x720 / 2400x1080 / 1024x768 | 34/34 PASS at each resolution |
| Smoke test, headless | 34/34 PASS |
| Main scene launch (`--quit-after 300`) | No errors or warnings |
| Temporary probe: desktop click recaptures the mouse in the world (probe deleted afterwards) | PASS |
| Temporary probe: default `ui_cancel` bindings in 4.7 | Escape only |

The `SafeArea` polling path only runs on mobile. It can't be exercised on desktop and still needs checking on a phone with a notch, rotated both ways.

### Remaining concerns

These are not blocking and none were changed in this review:

1. **Physics interpolation is off.** Many Android phones run at 90 or 120 Hz while physics ticks at 60 Hz, so judder in the camera and player is likely on device. Before turning on `physics/common/physics_interpolation`, the camera rig, which rotates in `_process`, would need `physics_interpolation_mode = OFF` so mouse and touch look doesn't lag. Evaluate this during the first device playtest.
2. **Android system bars.** `display/window/size/mode` is windowed, so on Android the status and navigation bars may stay visible (not immersive). Android 15 (target SDK 35) also enforces edge-to-edge. Decide on fullscreen/immersive and edge-to-edge when creating the export preset, and re-check `SafeArea` with that setting.
3. **Tests would ship in exports.** `game/tests/` will be packed into builds unless the export presets exclude it (e.g. an `exclude_filter` of `tests/*`).
4. **Shadow cost on low-end phones.** The directional shadow (60 m distance) is the most expensive thing in the scene. Profile it on a low-end device before adding more lights.
5. **Mobile renderer on Windows.** The Mobile renderer with D3D12 works for the prototype. Decide whether the Steam build should switch to Forward+ before investing in visuals.
6. **Summer Engine leftovers.** `AGENTS.md` still contains only Summer Engine setup commands, while the workflow rules live in `BUILD_STATUS.md`. If Summer is dropped, `AGENTS.md`, `.mcp.json`, `.claude/skills`, `.cursor/skills`, `game/.summer/` and `game/project.godot.bak` can be removed together. Left as-is, since that decision belongs to the owner.
