class_name ThirdPersonCamera
extends Node3D
## Orbiting third-person camera rig. This node yaws; the child SpringArm3D
## pitches and keeps the camera out of world geometry.

@export var min_pitch_degrees := -70.0
@export var max_pitch_degrees := 35.0
@export var initial_pitch_degrees := -15.0

var yaw := 0.0
var pitch := 0.0

@onready var _spring_arm: SpringArm3D = $SpringArm3D


func _ready() -> void:
	yaw = rotation.y
	pitch = deg_to_rad(initial_pitch_degrees)
	_apply_rotation()


func _process(_delta: float) -> void:
	var look := GameInput.consume_look_delta()
	if look == Vector2.ZERO:
		return
	yaw = wrapf(yaw - look.x, -PI, PI)
	pitch = clampf(pitch - look.y, deg_to_rad(min_pitch_degrees), deg_to_rad(max_pitch_degrees))
	_apply_rotation()


func _apply_rotation() -> void:
	rotation = Vector3(0.0, yaw, 0.0)
	_spring_arm.rotation = Vector3(pitch, 0.0, 0.0)
