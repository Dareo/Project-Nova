extends Node3D

var ActiveWeapon : bool = true
@export var Player : PlayerCharacter
@export var Animations : AnimationPlayer
@export var RayCast : RayCast3D
@export var TopAnimationSpeed : float = 1.2
func idle():
	Animations.play("Idle")
func Shoot():
	Animations.play("Shoot")
	await get_tree().create_timer(.23).timeout
	Animations.play("Shoot", -1, -TopAnimationSpeed, true)

func Moving():
	Animations.play("Moving")

func set_animation_speed(speed : float) -> void:
	var alpha = remap(speed, 0.0, Player.velocity.length() , 0.0, 1.0)
	Animations.speed_scale = lerp(0.0, TopAnimationSpeed, alpha)


func _process(delta: float) -> void:
	if !ActiveWeapon:
		return

	if Input.is_action_just_pressed('Attack'):
		if RayCast.is_colliding():
			print("hit")
		await Shoot()
		return
	var vel = Player.get_real_velocity()
	vel.y = 0

	if vel.length() <= 0:
		Animations.speed_scale = 1
		idle()
		return

	Moving()
	set_animation_speed(vel.length())

