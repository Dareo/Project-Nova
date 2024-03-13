extends CharacterBody3D
class_name PlayerCharacter

@export_category("First Person Controller")

@export_group("Movement")
@export var JUMP_VELOCITY : float = 4.5


@export_group("Sprinting")
@export var SprintSpeed : float = 7.0


@export_group("Camera")
@export var MainCamera : Camera3D
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



func CameraLook(Movement : Vector2):

	CameraRotation += Movement
	CameraRotation.y = clamp(CameraRotation.y, deg_to_rad(TiltLowerLimit),deg_to_rad(TiltUpperLimit))

	transform.basis = Basis()
	MainCamera.transform.basis = Basis()

	rotate_object_local(Vector3(0,1,0), -CameraRotation.x) # first rotate y
	MainCamera.rotate_object_local(Vector3(1,0,0), -CameraRotation.y) # then rotate x



func _physics_process(delta: float) -> void:


	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY



func UpdateGravity(delta : float) -> void:
	velocity.y -= gravity * delta

func UpdateInput(speed : float, acceleration : float, deacceleration : float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.

	var input_dir := Input.get_vector("Left", "Right", "Up", "Down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()


	if direction:
		velocity.x = lerp(velocity.x, direction.x * speed, acceleration)
		velocity.z = lerp(velocity.z, direction.z * speed, acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, deacceleration)
		velocity.z = move_toward(velocity.z, 0, deacceleration)

func UpdateVelocity() -> void:
		move_and_slide()
