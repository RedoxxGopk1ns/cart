extends Node3D

@export var spawn_location : Vector3
@export var spawn_rotation : Vector3

func _ready() -> void:
	Global.Track = self
