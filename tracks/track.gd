extends Node3D

@export var spawn_location : Vector3 = Vector3(0, 0, 0)
@export var spawn_rotation : float = deg_to_rad(0)

func _ready() -> void:
	Global.Track = self
