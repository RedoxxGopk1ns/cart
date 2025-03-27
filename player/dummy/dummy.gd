class_name Dummy
extends VehicleBody3D


@export var player_id : int = -1
@export var CC = 200
@export var Accelaration =  1500
@export var steer_angle =  deg_to_rad(6)
@export var steer_speed = 2
@export var brake_power = 100
@export var brake_speed = 5000



@onready var itemManager  = $ItemManager

var immune : bool = false :
	set(value):
		if value == true :
			print("set true")
			immune = true
			await itemManager.get_tree().create_timer(2).timeout
			immune = false




var buttons : Dictionary
var brake_button : String
var accelerate_button : String
var steer_right_button : String
var steer_left_button : String


func _physics_process(delta: float) -> void:
	#itemManager.update(delta)
	
	pass

func hitstun(duration : float)->void:
	#print(immune)
	if immune == false:
		#print("stunned")
		linear_velocity = Vector3.ZERO
		immune = true
	else : return
