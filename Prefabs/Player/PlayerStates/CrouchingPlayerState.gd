extends State
class_name CrouchingPlayerState


@export var Player : PlayerCharacter
@export var Animations : AnimationPlayer
@export var HeadBangDetection : ShapeCast3D
@export var CrouchingSpeed : float = 2
@export var AccelerationSpeed : float = 0.1
@export var DeaccelerationSpeed : float = 0.25
@export var CrouchAnimationSpeed : float = 5.0

func enter() -> void:
	Animations.play("Crouch",-1.0, CrouchAnimationSpeed)

func update(delta : float) -> void:

	if Input.is_action_just_released('Crouch'):
		Uncrouch()

func Uncrouch() -> void:

	if HeadBangDetection.is_colliding():
		await get_tree().create_timer(0.1).timeout
		Uncrouch()
		return

	Animations.play("Crouch", -1, -CrouchAnimationSpeed, true)
	if Animations.is_playing():
		await  Animations.animation_finished
	Transition.emit("IdlePlayerState")


func physics_update(delta: float) -> void:
	Player.UpdateGravity(delta)
	Player.UpdateInput(CrouchingSpeed, AccelerationSpeed, DeaccelerationSpeed)
	Player.UpdateVelocity()

func exit() -> void:
	Animations.speed_scale = 1.0
