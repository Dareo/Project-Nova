extends State
class_name JumpingPlayerState

@export_category("Jumping State")
@export var Player : PlayerCharacter
@export var Animations : AnimationPlayer
@export var JumpForce : float = 7.0
@export var AccelerationSpeed : float = 0.1
@export var DeaccelerationSpeed : float = 0.25
@export var TopAnimationSpeed : float = 1.6

func enter() -> void:
	Animations.pause()
	Player.velocity.y = JumpForce

func update(delta : float) -> void:
	if Player.is_on_floor():
		return

	Transition.emit("FallingPlayerState")

# updates the player movement and gravity each physics process tick
func physics_update(delta: float) -> void:
	Player.UpdateInput(JumpForce, AccelerationSpeed, DeaccelerationSpeed)
	Player.UpdateVelocity()

## sets the animation speed
func set_animation_speed(speed : float) -> void:
	var alpha = remap(speed, 0.0, JumpForce, 0.0, 1.0)
	Animations.speed_scale = lerp(0.0, TopAnimationSpeed, alpha)

func exit() -> void:
	Animations.speed_scale = 1.0

