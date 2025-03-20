extends VehicleBody3D

@export var CC = 200
@export var Accelaration =  10

var steer_angle =  deg_to_rad(10)
var steer_speed = 2

var brake_power = 40
var brake_speed = 40

@export var player_id : int = -1




func _physics_process(delta: float) -> void:
	#var throttle_input = Input.get_axis("brake", "accelerate")
	#engine_force = lerp(engine_force, throttle_input * CC, Accelaration * delta)
	engine_force = Input.get_axis("brake", "accelerate") * CC
	
	steering = move_toward(steering, Input.get_axis("steer_right","steer_left") * steer_angle, delta * steer_speed)
	
	
	#var brake_input =  Input.get_action_strength("brake")
	#brake = lerp(brake, brake_input * brake_power, brake_speed * delta)
