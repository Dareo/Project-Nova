extends State
class_name SlidingPlayerState


@export var Player : PlayerCharacter
@export var Animations : AnimationPlayer
@export var HeadBangDetection : ShapeCast3D
@export var SlidingSpeed : float = 5
@export var AccelerationSpeed : float = 0.1
@export var DeaccelerationSpeed : float = 0.25
@export var SlideAnimationSpeed : float = 5.0

var normal_velocity

func enter() -> void:
	Player.velocity = Player.velocity.normalized()
	normal_velocity = Player.velocity
	Animations.get_animation("Sliding").track_set_key_value(4,0,Player.velocity.length())
	Animations.speed_scale = 1.0
	Animations.play("Sliding", -1.0, SlideAnimationSpeed)

func update(delta : float) -> void:
	if !Player.is_on_floor():
		await finish()
		Transition.emit("FallingPlayerState")

	Player.velocity = normal_velocity * SlidingSpeed

	if Input.is_action_just_pressed('Jump'):
		await finish()
		Player.velocity *= 1.7
		Transition.emit("JumpingPlayerState")


func physics_update(delta: float) -> void:
	Player.UpdateGravity(delta)
	Player.UpdateVelocity()


func finish() -> void:
	Animations.play("Crouch", -1, -SlideAnimationSpeed * 2, true)
	if Animations.is_playing():
		await  Animations.animation_finished
	# Player is still in Air
	if !Player.is_on_floor():
		return

	if HeadBangDetection.is_colliding():
		Transition.emit("CrouchingPlayerState")
		return

	# Player is on the ground
	if Player.velocity.length() == 0:
		Transition.emit("IdlePlayerState")
		return


	if Input.is_action_pressed('Sprint'):
		Transition.emit("SprintingPlayerState")
		return



	Transition.emit("WalkingPlayerState")
