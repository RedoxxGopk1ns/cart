extends Area3D

@export var player : Player 


func _on_body_entered(body: Node3D) -> void:
	if body is GreenShell :
		player.hitstun(1)
