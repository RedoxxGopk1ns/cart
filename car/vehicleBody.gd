extends VehicleBody3D

@export var steer = 0.9
@export var hp : int



func _physics_process(delta: float) -> void:
	steering = move_toward(steering, Input.get_axis("steer_right","steer_left")* steer, delta * 10)
	engine_force = Input.get_axis("brake","accelerate") * hp
	
