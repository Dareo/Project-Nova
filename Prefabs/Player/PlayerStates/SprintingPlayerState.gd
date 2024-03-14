extends State
class_name SprintingPlayerState

@export var Player : PlayerCharacter
@export var Animations : AnimationPlayer
@export var SprintingSpeed : float = 7.0
@export var AccelerationSpeed : float = 0.1
@export var DeaccelerationSpeed : float = 0.25
@export var TopAnimationSpeed : float = 1.6


func enter() -> void:

	Animations.play("Sprinting", 0.5, 1.0)

func update(delta : float) -> void:
	set_animation_speed(Player.velocity.length())
	if !Player.is_on_floor():
		Transition.emit("FallingPlayerState")

	if Input.is_action_just_pressed('Crouch'):
		Transition.emit("SlidingPlayerState")

	if Input.is_action_just_pressed('Jump'):
		Transition.emit("JumpingPlayerState")


	if Input.is_action_just_released("Sprint"):
		Transition.emit("WalkingPlayerState")

func physics_update(delta: float) -> void:
	Player.UpdateGravity(delta)
	Player.UpdateInput(SprintingSpeed, AccelerationSpeed, DeaccelerationSpeed)
	Player.UpdateVelocity()


func set_animation_speed(speed : float) -> void:
	var alpha = remap(speed, 0.0, SprintingSpeed, 0.0, 1.0)
	Animations.speed_scale = lerp(0.0, TopAnimationSpeed, alpha)

func exit() -> void:
	Animations.speed_scale = 1.0
