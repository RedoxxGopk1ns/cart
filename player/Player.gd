class_name Player
extends VehicleBody3D


@export var player_id : int = -1
@export var CC = 200
@export var Accelaration =  10

@onready var camera : Camera3D = $Camera3D

var steer_angle =  deg_to_rad(8)
var steer_speed = 3

var brake_power = 80
var brake_speed = 80

var buttons : Dictionary
var brake_button : String
var accelerate_button : String

func _ready() -> void:
	set_input_id(player_id)

func set_input_id(i : int) -> void:
	player_id = i
	brake_button = "brakePL" + str(i)
	accelerate_button = "acceleratePL" + str(i)

func _physics_process(delta: float) -> void:
	#var throttle_input = Input.get_axis("brake", "accelerate")
	#engine_force = lerp(engine_force, throttle_input * CC, Accelaration * delta)
	engine_force = Input.get_axis(brake_button, accelerate_button) * CC
	
	steering = move_toward(steering, Input.get_axis("steer_right","steer_left") * steer_angle, delta * steer_speed)
	
	
	#var brake_input =  Input.get_action_strength("brake")
	#brake = lerp(brake, brake_input * brake_power, brake_speed * delta)
