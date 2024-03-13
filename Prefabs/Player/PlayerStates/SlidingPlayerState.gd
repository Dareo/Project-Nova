extends State
class_name SlidingPlayerState


@export var Player : PlayerCharacter
@export var Animations : AnimationPlayer
@export var HeadBangDetection : ShapeCast3D
@export var SlidingSpeed : float = 2
@export var TiltAmount : float = 0.9
@export var AccelerationSpeed : float = 0.1
@export var DeaccelerationSpeed : float = 0.25
@export var SlideAnimationSpeed : float = 5.0

func enter() -> void:
	Animations.get_animation("Sliding").track_set_key_value(4,0,Player.velocity.length())
	Animations.speed_scale = 1.0
	Animations.play("Sliding", -1.0, SlideAnimationSpeed)


func physics_update(delta: float) -> void:
	Player.UpdateGravity(delta)
	Player.UpdateVelocity()

func SetTilt(player_rotation) -> void:
	var tilt = Vector3.ZERO
	tilt.z = clamp(TiltAmount * player_rotation, -0.1, 0.1)
	if tilt.z == 0.0:
		tilt.z = 0.05

	Animations.get_animation("Sliding").track_find_value(8,1,tilt)
	Animations.get_animation("Sliding").track_find_value(8,2,tilt)

func finish():
	Transition.emit("crouchingPlayerState")
