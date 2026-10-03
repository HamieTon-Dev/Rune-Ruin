# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Workflow

Read `BUILD_STATUS.md` before starting and update it when a task is done. It sets the rules, the current milestone and the agent roles: Cursor implements, Claude Code reviews, debugs and tests. Android is the primary target, Windows/Steam must keep working, and the long-term architecture is a server-authoritative MMO (`server/` is planned for Nakama and is still empty). Don't start features outside the current milestone.

## Commands

The project lives in `game/` and is plain Godot 4.7.2 (Mobile renderer, Jolt physics). The binary is `D:\Godot_v4.7.2-stable_win64_console.exe`.

```
cd game
<godot> --headless --path . --import                                   # re-import; surfaces parse errors
<godot> --path . res://tests/smoke_test.tscn                           # end-to-end smoke test, exit 0 = pass
<godot> --path . --resolution 2400x1080 res://tests/smoke_test.tscn   # check other aspect ratios
<godot> --path . res://tests/smoke_test.tscn -- --shots-dir=C:/temp/shots
<godot> --path . -- --touch-ui                                         # play with touch UI on desktop (--no-touch-ui forces it off)
```

Run the smoke test **windowed** to verify touch input; GUI touch routing isn't reliable headless. There is no separate unit-test framework. To add coverage, add a section to `tests/smoke_test.gd`. Each section must increment `_sections_completed`, otherwise the run fails.

## Architecture

- **Input is routed through the `GameInput` autoload** (`autoload/game_input.gd`). Gameplay code reads only `get_move_vector()`, `consume_look_delta()` and `consume_action_press()`. Device sources write in: keyboard, mouse and gamepad are read inside `GameInput`, and the touch controls (`ui/touch_controls.tscn`) call `set_virtual_move` / `add_touch_look` / `press_virtual_action`. Never read `Input` or touch events directly from gameplay scripts.
- **Default bindings are registered at runtime** in `_register_default_actions()`, and only for actions not already in the Input Map. To add an action, add it there (or in Project Settings).
- **Gameplay mode is a flag.** `GameInput.gameplay_active` gates all input and mouse capture. Gameplay scenes set it true in `_ready` and false on exit.
- **Scene flow and the Android back button** live in the `Game` autoload (`autoload/game.gd`). A scene can consume a back press by implementing `handle_back() -> bool`.
- **Player rig:** `PlayerController` (CharacterBody3D) never rotates; only its `Model` child turns to face movement. `ThirdPersonCamera` yaws, and its SpringArm3D child pitches. Movement is made camera-relative using `camera_rig.yaw`.
- **UI scaling:** the base size is 1280x720 with `canvas_items` + `expand` stretch. Place UI with anchors inside a `SafeArea` control (`scripts/ui/safe_area.gd`), which insets for notches and cutouts on mobile.
- **Physics layers:** 1 = world, 2 = player.
- **Godot 4.7 class names:** 4.7 adds a native `VirtualJoystick` class, so avoid `class_name`s that may clash with engine classes.

## Repo leftovers

`AGENTS.md`, `.mcp.json`, `.claude/skills`, `.cursor/skills` and `game/.summer/` come from Summer Engine, which `BUILD_STATUS.md` says is not part of the workflow.
