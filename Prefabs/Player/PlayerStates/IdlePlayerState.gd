extends State
class_name PlayerIdleState

@export_category("Idle State")
@export var Player : PlayerCharacter
@export var WalkingSpeed : float = 5.0
@export var AccelerationSpeed : float = 0.1
@export var DeaccelerationSpeed : float = 0.25
@export var Animations : AnimationPlayer
func enter() -> void:
	Animations.pause()

func update(delta : float) -> void:
	if Input.is_action_just_pressed('Crouch') and Player.is_on_floor():
		Transition.emit("CrouchingPlayerState")

	if Player.velocity.length() > 0.0:
		print(Player.velocity.length())
		Transition.emit("WalkingPlayerState")

func physics_update(delta: float) -> void:
	Player.UpdateGravity(delta)
	Player.UpdateInput(WalkingSpeed,AccelerationSpeed, DeaccelerationSpeed)
	Player.UpdateVelocity()

