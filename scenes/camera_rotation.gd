extends SpringArm3D

const MOUSE_SENSIVITY = 0.05
const JOYPAD_SENSIVITY = 2.0

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _process(_delta):
	handle_joypad_camera()

func _input(event):
	handle_mouse_camera(event)

func handle_mouse_camera(event):
	if event is InputEventMouseMotion:
		rotation_degrees.x -= event.relative.y * MOUSE_SENSIVITY
		rotation_degrees.x = clamp(rotation_degrees.x, -90.0, 30.0)
		
		rotation_degrees.y -= event.relative.x * MOUSE_SENSIVITY
		rotation_degrees.y = wrapf(rotation_degrees.y, 0.0, 360.0)
	
func handle_joypad_camera():
	if Input.get_connected_joypads().size() == 0:
		return

	var look = Input.get_vector("look_left", "look_right", "look_up", "look_down")
	rotation_degrees.x -= look.y * JOYPAD_SENSIVITY
	rotation_degrees.x = clamp(rotation_degrees.x, -90.0, 30.0)
	
	rotation_degrees.y -= look.x * JOYPAD_SENSIVITY
	rotation_degrees.y = wrapf(rotation_degrees.y, 0.0, 360.0)
	

	
	
	
