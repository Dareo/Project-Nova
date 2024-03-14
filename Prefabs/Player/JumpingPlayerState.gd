extends State
class_name JumpingPlayerState

@export_category("Jumping State")
@export var Player : PlayerCharacter
@export var Animations : AnimationPlayer
@export var JumpForce : float = 12
@export var AccelerationSpeed : float = 0.1
@export var DeaccelerationSpeed : float = 0.25
@export var TopAnimationSpeed : float = 1.6

func enter() -> void:
	Animations.pause()
	Player.velocity.y = JumpForce

func update(delta : float) -> void:

	if Player.is_on_floor():
		if Input.is_action_pressed('Sprint'):
			Transition.emit("SprintingPlayerState")
			return

		Transition.emit("IdlePlayerState")
		return

	if Player.get_real_velocity().y < 0:

		Transition.emit("FallingPlayerState")
		return

	if Input.is_action_just_released("Jump"):
		Player.velocity.y = move_toward(Player.velocity.y, 0, JumpForce/4)



# updates the player movement and gravity each physics process tick
func physics_update(delta: float) -> void:
	Player.UpdateGravity(delta)
	Player.UpdateInput(JumpForce, AccelerationSpeed, DeaccelerationSpeed)
	Player.UpdateVelocity()

## sets the animation speed
func set_animation_speed(speed : float) -> void:
	var alpha = remap(speed, 0.0, JumpForce, 0.0, 1.0)
	Animations.speed_scale = lerp(0.0, TopAnimationSpeed, alpha)

func exit() -> void:
	Animations.speed_scale = 1.0

