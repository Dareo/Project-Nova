extends State
class_name WalkingPlayerState

@export_category("Walking State")
@export var Player : PlayerCharacter
@export var Animations : AnimationPlayer
@export var WalkingSpeed : float = 5.0
@export var AccelerationSpeed : float = 0.1
@export var DeaccelerationSpeed : float = 0.25
@export var TopAnimationSpeed : float = 2.2

func enter() -> void:
	Animations.play("Walking", -1.0, 1.0)

func update(delta : float) -> void:
	set_animation_speed(Player.velocity.length())
	if Input.is_action_just_pressed("Sprint") and Player.is_on_floor():
		Transition.emit("SprintingPlayerState")

	if Input.is_action_just_pressed('Crouch') and Player.is_on_floor():
		Transition.emit("CrouchingPlayerState")

	if Player.velocity.length() == 0.0 and Player.is_on_floor():
		emit_signal("Transition",&"IdlePlayerState")

func physics_update(delta: float) -> void:
	Player.UpdateGravity(delta)
	Player.UpdateInput(WalkingSpeed,AccelerationSpeed, DeaccelerationSpeed)
	Player.UpdateVelocity()

func set_animation_speed(speed : float) -> void:
	var alpha = remap(speed, 0.0, WalkingSpeed, 0.0, 1.0)
	Animations.speed_scale = lerp(0.0, TopAnimationSpeed, alpha)

func exit() -> void:
	Animations.speed_scale = 1.0
