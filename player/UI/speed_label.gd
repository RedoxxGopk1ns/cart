extends Label

@export var player : Node3D
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	text = str(abs(int(player.linear_velocity.length())))
