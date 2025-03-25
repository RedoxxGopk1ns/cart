class_name Player
extends VehicleBody3D


@export var player_id : int = -1
@export var CC = 200 * 60
@export var Accelaration =  200 * 60
@export var steer_angle =  deg_to_rad(10)
@export var steer_speed = 2
@export var brake_power = 300 * 60
@export var brake_speed = 5000


@onready var track : Node3D = get_parent()

@onready var camera : Camera3D = $Camera3D
@onready var itemManager : ItemManager = $ItemManager

var immune : bool = false :
	set(value):
		if value == true :
			immune = true
			await itemManager.get_tree().create_timer(2).timeout
			immune = false



var buttons : Dictionary
var brake_button : String
var accelerate_button : String
var steer_right_button : String
var steer_left_button : String
var use_item_button : String

#func _ready() -> void:
	#set_input_id(player_id)

func set_input_id(i : int) -> void:
	
	player_id = i
	brake_button = "brakePL" + str(i)
	accelerate_button = "acceleratePL" + str(i)
	steer_right_button = "steer_rightPL" + str(i)
	steer_left_button = "steer_leftPL" + str(i)
	use_item_button = "use_itemPL" + str(i)


func _physics_process(delta: float) -> void:
	var AB_axis : float  = Input.get_axis(brake_button, accelerate_button)
	#var AB_axis : float  = Input.get_axis("brake","accelerate")
	if AB_axis>0:
		engine_force = AB_axis * Accelaration * delta
		#linear_velocity = linear_velocity.clampf(0,100)
	if AB_axis<0:
		engine_force = AB_axis * brake_power * delta
	if AB_axis == 0:
		engine_force = 0
	steering = move_toward(steering, Input.get_axis(steer_right_button,steer_left_button) * steer_angle, delta * steer_speed)
	#steering = move_toward(steering, Input.get_axis("steer_right","steer_left") * steer_angle, delta * steer_speed)
	itemManager.update(delta)
	#if Input.is_action_pressed("debug_button"):
		#hitstun(1)
	

func hitstun(duration : float)->void:
	#print(immune)
	if immune == false:
		#print("stunned")
		linear_velocity = Vector3.ZERO
		immune = true
	else : return
