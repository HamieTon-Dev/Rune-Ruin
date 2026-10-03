# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project state

**Rune & Ruin** is an early-stage scaffold: there is no gameplay code yet. Most folders exist but are empty, so don't assume conventions beyond what's listed here. Look at the actual files before relying on any structure.

## Layout

- `game/`: the Godot 4.7 project (`game/project.godot`), driven through **Summer Engine**, a Godot-based editor. Settings: Mobile renderer, Jolt Physics, D3D12 on Windows, `canvas_items` stretch with `expand` aspect. A `[dotnet]` assembly name is set, but scripts are GDScript unless the user says C#.
  - Empty subfolders are in place for `scenes/`, `scripts/`, `autoload/`, `ui/`, `assets/`, `audio/`, `materials/` and `shaders/`.
  - `.summer/local/` holds local-only Summer state (git-ignored). `/android/` and `.godot/` are also ignored.
- `server/`: planned backend, with empty `nakama/`, `runtime/` and `database/` folders. The intended stack is a Nakama game server.
- `docs/`: planned design docs, with empty `android/`, `architecture/`, `gameplay/` and `networking/` folders. Android is a target platform.

## Tooling: Summer Engine MCP

The `summer-engine` MCP server (`.mcp.json`, run via `npx summer-engine@latest mcp`) controls the running Summer Engine editor. Setup and health checks come from `AGENTS.md`:

```
npx.cmd -y summer-engine@latest login
npx.cmd -y summer-engine@latest setup claude-code --scope project --yes
npx.cmd -y summer-engine@latest doctor
```

Working rules:
- Call `summer_get_project_context` first in a session. It binds the session to the open project.
- Do not hand-edit `.tscn` / `.tres` files that are open in the editor. The editor's in-memory copy overwrites your edit when it saves. Change open scenes through the `summer_*` tools; scripts, configs and closed scenes can be edited directly.
- Before building a feature, check the Summer library (`summer_search_library` → `summer_read_library`) for existing skills and templates.
- After a playthrough, read `summer_get_diagnostics`. Runtime errors live in the debugger, not only the console.
- A screenshot that is all black usually means the viewport hadn't redrawn yet. Capture it again before drawing conclusions.
- Project skills live in `.claude/skills/` and `.cursor/skills/`, and `/summer <request>` routes a request to the right skill. Use `playtesting-a-feature` / `verifying-scenes` before claiming that gameplay or scene work is done.

There is no build, lint or test pipeline yet. You verify work by running the game through the MCP tools (`summer_play`, `summer_screenshot`, `summer_get_diagnostics`).
