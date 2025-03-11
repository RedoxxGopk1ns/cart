extends RigidBody3D

var ownerl
var hit
@export var speed : float = 10

func _ready() -> void:
	apply_central_force(-global_transform.basis.z * speed)
