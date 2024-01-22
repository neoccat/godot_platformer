extends CharacterBody3D

const SPEED = 7.0
const BLEND_INTERPOLATION_SPEED = 8.5
const JUMP_VELOCITY = 4.5

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var spring_arm = $CameraOrigin/SpringArm3D

var current_blend_position = Vector2.ZERO

func _physics_process(delta):
	handle_movement(delta)

func handle_movement(delta):
	var move_direction = get_character_move_direction()
	if move_direction:
		$RobotArmature.look_at(transform.origin - Vector3(move_direction.x, 0, move_direction.z))
	
	set_IWR_interpolated_blend_position(move_direction, delta)
	set_interpolated_velocity(move_direction, delta)
	handle_jump_and_gravity(delta)
	
	move_and_slide()

func get_character_move_direction() -> Vector3:
	var move_direction = Vector3.ZERO
	move_direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	move_direction.z = Input.get_action_strength("move_back") - Input.get_action_strength("move_forward")
	return move_direction.rotated(Vector3.UP, spring_arm.rotation.y)

func set_IWR_interpolated_blend_position(move_direction, delta):
	var target_blend_position = Vector2(move_direction.x, move_direction.z)
	current_blend_position = current_blend_position.lerp(target_blend_position, BLEND_INTERPOLATION_SPEED * delta)
	$AnimationTree.set("parameters/IWR/blend_position", current_blend_position)

func set_interpolated_velocity(move_direction, delta):
	var target_velocity = move_direction * SPEED
	velocity.x = lerp(velocity.x, target_velocity.x, BLEND_INTERPOLATION_SPEED * delta)
	velocity.z = lerp(velocity.z, target_velocity.z, BLEND_INTERPOLATION_SPEED * delta)

func handle_jump_and_gravity(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY