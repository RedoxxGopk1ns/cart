extends Node3D

@export var spawn_location : Vector3 = Vector3(-14.42, 0.42, 58.706)
@export var spawn_rotation : float = -88.1

func _ready() -> void:
	Global.Track = self
