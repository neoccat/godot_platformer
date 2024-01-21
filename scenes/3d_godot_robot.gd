extends CharacterBody3D

const SPEED = 7.0
const JUMP_VELOCITY = 4.5

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var spring_arm = $CameraOrigin/SpringArm3D

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	var move_direction = Vector3.ZERO
	move_direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	move_direction.z = Input.get_action_strength("move_back") - Input.get_action_strength("move_forward")
	move_direction = move_direction.rotated(Vector3.UP, spring_arm.rotation.y).normalized()
	
	if move_direction:
		$RobotArmature.look_at(transform.origin - Vector3(move_direction.x, 0, move_direction.z))
	
	velocity.x = move_direction.x * SPEED
	velocity.z = move_direction.z * SPEED
	
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	move_and_slide()
