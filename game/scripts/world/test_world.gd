extends Node3D
## Milestone 0 sandbox: enables gameplay input while this scene is loaded.


func _ready() -> void:
	GameInput.gameplay_active = true


func _exit_tree() -> void:
	GameInput.gameplay_active = false
