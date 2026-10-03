# Rune & Ruin Agent Rules

Rune & Ruin is an Android-first 3D fantasy MMO built in Godot 4.

Primary platform:
Android / Google Play

Future platform:
Windows / Steam

Engine:
Godot 4

Language:
GDScript

Backend later:
Nakama

Database later:
PostgreSQL

## Agent Roles

Cursor:
Primary implementation agent.

Claude Code:
Reviewer, debugger, architecture reviewer, refactoring assistant, and tester.

ChatGPT:
Project architecture, task planning, repository review, and build coordination.

## Required Reading

Before making changes, read:

1. AGENTS.md
2. GAME_DESIGN.md
3. BUILD_STATUS.md

Claude Code should also read CLAUDE.md.

## Architecture Rules

The game is local-first during development, but must remain compatible with a future server-authoritative MMO backend.

Do not tightly couple gameplay systems to local persistence.

Future server authority must control:

- damage
- healing
- XP
- levels
- currency
- loot
- inventory quantities
- item creation
- crafting
- quest completion
- equipment validation
- PvP results
- boss rewards
- guild data
- marketplace transactions

## Platform Rules

Android is the primary platform.

Windows and Steam compatibility must remain possible.

Keep touch input separate from gameplay logic.

Keep keyboard, mouse, controller, and touch input behind shared abstractions.

Do not place Android-specific logic directly inside combat or character systems.

## Development Rules

Before modifying code:

1. Read the required project documents.
2. Inspect the existing implementation.
3. Do not duplicate systems.
4. Do not silently redesign architecture.
5. Make only changes related to the current task.
6. Run existing tests.
7. Check Godot for parse/runtime errors.
8. Update BUILD_STATUS.md.
9. Report files changed.
10. Stop after the assigned task.

## Current Build Strategy

Build in milestones.

Do not attempt to implement the entire MMO at once.

Prefer reusable and data-driven systems.

Examples:

- AbilityData
- ClassData
- SpecializationData
- ItemData
- QuestData
- NPCData

The long-term game vision lives in GAME_DESIGN.md.

The current task and progress live in BUILD_STATUS.md.
