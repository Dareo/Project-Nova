extends CenterContainer

@export_category("Reticle")

@export_group("Dot Properties")
@export var DotRadius : float = 1.0
@export var DotColor : Color = Color.WHITE

@export_category("Redicle Lines")
@export var ReticleLines : Array[Line2D]
@export var PlayerController : CharacterBody3D
@export var ReticleLineSpeed : float = 0.25
@export var ReticleDistance : float = 2.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	adjust_reticle_lines()

func _draw() -> void:
	draw_circle(Vector2(0,0), DotRadius, DotColor)

func adjust_reticle_lines():
	var vel = PlayerController.get_real_velocity()
	var origin = Vector3.ZERO
	var pos = Vector2.ZERO
	var speed = origin.distance_to(vel)

	# Ajust Reticle Line Position
	ReticleLines[0].position = lerp(ReticleLines[0].position, pos + Vector2(0, -speed * ReticleDistance), ReticleLineSpeed) # top
	ReticleLines[1].position = lerp(ReticleLines[1].position, pos + Vector2(speed * ReticleDistance, 0), ReticleLineSpeed) # top
	ReticleLines[2].position = lerp(ReticleLines[2].position, pos + Vector2(0, speed * ReticleDistance), ReticleLineSpeed) # top
	ReticleLines[3].position = lerp(ReticleLines[3].position, pos + Vector2( -speed * ReticleDistance, 0), ReticleLineSpeed) # top

