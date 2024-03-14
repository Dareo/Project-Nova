extends Camera3D

@export var MainCamera : Camera3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_transform = MainCamera.global_transform
