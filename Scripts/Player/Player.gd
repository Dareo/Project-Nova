extends CharacterBody3D
class_name PlayerCharacter

@export_category("First Person Controller")


@export_group("Camera")
@export var MainCamera : Camera3D
@export var DefaultFov : float = 75
@export var MaxFov : float = 120
@export_range(-90, 0) var TiltLowerLimit : float = -90
@export_range(0,90) var TiltUpperLimit : float = 90
@export_range(0.001, 0.005, 0.0001) var MouseSensitivity : float = 0.001
var CameraRotation = Vector2(0,0)
var CurrentRotation : float



# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")


func _ready() -> void:
	# set the mouse to the center of screen and makes invisable.
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent) -> void:
	# when press excape free the mouse
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	# checks for mouse motion and a apply the motion to camera rotation
	if event is InputEventMouseMotion:
		var MouseEvent = event.relative * MouseSensitivity
		CameraLook(MouseEvent)

func CameraFovUpdate(acceleration : float, deacceleration : float) -> void:
	var direction = get_real_velocity()
	direction.y = 0

	if get_real_velocity().length() > 0:
		MainCamera.fov = move_toward(MainCamera.fov, DefaultFov + direction.length() * 1.5, acceleration * 2)
		return

	MainCamera.fov = lerp(MainCamera.fov, DefaultFov, deacceleration * .2)




func CameraLook(Movement : Vector2):

	CameraRotation += Movement
	CameraRotation.y = clamp(CameraRotation.y, deg_to_rad(TiltLowerLimit),deg_to_rad(TiltUpperLimit))

	transform.basis = Basis()
	MainCamera.transform.basis = Basis()

	rotate_object_local(Vector3(0,1,0), -CameraRotation.x) # first rotate y
	MainCamera.rotate_object_local(Vector3(1,0,0), -CameraRotation.y) # then rotate x



func UpdateGravity(delta : float) -> void:
	velocity.y -= gravity * delta

func UpdateInput(speed : float, acceleration : float, deacceleration : float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.

	var input_dir := Input.get_vector("Left", "Right", "Up", "Down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	CameraFovUpdate(acceleration, deacceleration)
	if direction:
		velocity.x = lerp(velocity.x, direction.x * speed, acceleration)
		velocity.z = lerp(velocity.z, direction.z * speed, acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, deacceleration)
		velocity.z = move_toward(velocity.z, 0, deacceleration)

func UpdateVelocity() -> void:
		move_and_slide()
