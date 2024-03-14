extends State

@export var Player : PlayerCharacter
@export var Animations : AnimationPlayer
@export var FallingMovementSpeed : float = 4.0
@export var AccelerationSpeed : float = 0.1
@export var DeaccelerationSpeed : float = 0.25
@export var TopAnimationSpeed : float = 1.6

@export var ExtraJumps : int = 1
var JumpCount : int

func enter() -> void:
	pass

func update(delta : float) -> void:
	# Player is still in Air
	if !Player.is_on_floor():
		if Input.is_action_just_pressed("Jump") and JumpCount > 0:
			JumpCount -= 1
			Transition.emit("JumpingPlayerState")

		return
	JumpCount = ExtraJumps
	# Player is on the ground
	if Player.velocity.length() == 0:
		Transition.emit("IdlePlayerState")
		return

	if Input.is_action_pressed('Sprint'):
		Transition.emit("SprintingPlayerState")
		return

	if Input.is_action_pressed('Crouch'):
		Transition.emit("CrouchingPlayerState")
		return
	Transition.emit("WalkingPlayerState")


# updates the player movement and gravity each physics process tick
func physics_update(delta: float) -> void:
	Player.UpdateGravity(delta)
	Player.UpdateInput(FallingMovementSpeed, AccelerationSpeed, DeaccelerationSpeed)
	Player.UpdateVelocity()

## sets the animation speed
func set_animation_speed(speed : float) -> void:
	var alpha = remap(speed, 0.0, FallingMovementSpeed, 0.0, 1.0)
	Animations.speed_scale = lerp(0.0, TopAnimationSpeed, alpha)

func exit() -> void:
	Animations.speed_scale = 1.0

