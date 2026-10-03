class_name PlayerController
extends CharacterBody3D
## Third-person character movement. Reads intent only from GameInput, so it is
## identical on desktop, gamepad and touch.

@export_group("Movement")
@export var move_speed := 6.0
@export var ground_acceleration := 45.0
@export var ground_deceleration := 55.0
@export var air_acceleration := 15.0
@export var turn_speed := 12.0

@export_group("Jump")
@export var jump_velocity := 7.0
@export var fall_gravity_multiplier := 1.6
@export var coyote_time := 0.1
@export var jump_buffer_time := 0.12

@export_group("Safety")
@export var kill_height := -25.0

@export_group("Nodes")
@export var camera_rig: ThirdPersonCamera
@export var model: Node3D

var _gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var _coyote_timer := 0.0
var _jump_buffer_timer := 0.0
var _spawn_transform: Transform3D


func _ready() -> void:
	_spawn_transform = global_transform


func _physics_process(delta: float) -> void:
	_update_jump_timers(delta)
	_apply_gravity(delta)
	_try_jump()
	_apply_horizontal_movement(delta)
	move_and_slide()

	if global_position.y < kill_height:
		respawn()


func respawn() -> void:
	global_transform = _spawn_transform
	velocity = Vector3.ZERO


func _update_jump_timers(delta: float) -> void:
	if GameInput.consume_action_press(GameInput.JUMP):
		_jump_buffer_timer = jump_buffer_time
	else:
		_jump_buffer_timer = maxf(_jump_buffer_timer - delta, 0.0)

	if is_on_floor():
		_coyote_timer = coyote_time
	else:
		_coyote_timer = maxf(_coyote_timer - delta, 0.0)


func _apply_gravity(delta: float) -> void:
	if is_on_floor():
		return
	var multiplier := fall_gravity_multiplier if velocity.y < 0.0 else 1.0
	velocity.y -= _gravity * multiplier * delta


func _try_jump() -> void:
	if _jump_buffer_timer > 0.0 and _coyote_timer > 0.0:
		velocity.y = jump_velocity
		_jump_buffer_timer = 0.0
		_coyote_timer = 0.0


func _apply_horizontal_movement(delta: float) -> void:
	var direction := _camera_relative_direction(GameInput.get_move_vector())
	var target := direction * move_speed
	var horizontal := Vector3(velocity.x, 0.0, velocity.z)

	var rate := air_acceleration
	if is_on_floor():
		rate = ground_acceleration if direction != Vector3.ZERO else ground_deceleration
	horizontal = horizontal.move_toward(target, rate * delta)
	velocity.x = horizontal.x
	velocity.z = horizontal.z

	if model and direction.length_squared() > 0.0001:
		var target_yaw := atan2(-direction.x, -direction.z)
		model.rotation.y = lerp_angle(model.rotation.y, target_yaw, 1.0 - exp(-turn_speed * delta))


## Input y is "back", so forward on the stick maps to the camera's -Z.
func _camera_relative_direction(input: Vector2) -> Vector3:
	var direction := Vector3(input.x, 0.0, input.y)
	if camera_rig:
		direction = direction.rotated(Vector3.UP, camera_rig.yaw)
	return direction
