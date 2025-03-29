class_name Lepra
extends RigidBody3D


@export var player_id : int = -1
@export var CC = 22000
@export var Accelaration =  200
@export var steer_angle =  30
@export var brake_power = 300
@export var slip : float = 0.5
@export var suspension_force : float = 60
@export var max_speed : float = 50
@export var dragCoefficient : float = 1
@export var turnGraph : Curve
@export var steer_strength : float = 60
@export var gravity_force : float = 20

@onready var camera : Camera3D = $Camera3D
@onready var itemManager : ItemManager 
@onready var FR_wheel : MeshInstance3D = $FR
@onready var FL_wheel : MeshInstance3D = $FL
@onready var Body_Mesh : MeshInstance3D = $body/body2
@onready var rays : Array = get_tree().get_nodes_in_group("Raycasts")
@onready var Front_Axle : Node3D = $FrontAxle
@onready var FloorRay : RayCast3D = $FloorRay

var collided : bool

var buttons : Dictionary
var brake_button : String
var accelerate_button : String
var steer_right_button : String
var steer_left_button : String
var use_item_button : String

var immune : bool = false :
	set(value):
		if value == true :
			immune = true
			await itemManager.get_tree().create_timer(2).timeout
			immune = false


#func _ready() -> void:
	#


func set_input_id(i : int) -> void:
	
	player_id = i
	brake_button = "brakePL" + str(i)
	accelerate_button = "acceleratePL" + str(i)
	steer_right_button = "steer_rightPL" + str(i)
	steer_left_button = "steer_leftPL" + str(i)
	use_item_button = "use_itemPL" + str(i)


func _physics_process(delta: float) -> void:
	for ray : RayCast3D in rays:
		ray.force_raycast_update()
		if ray.is_colliding():
			var collision_point = ray.get_collision_point()
			var dist = collision_point.distance_to(ray.global_transform.origin)
			apply_force(Vector3.UP * (1/dist) * suspension_force * delta,ray.global_transform.origin - global_transform.origin)
			
		#apply my own central force as  gravity when the car isnt on the groyund
		#lerp:correcting rotation force as a function of the angle difference of world vector_down and the vehicles rotation
		#else : apply_force(Vector3.DOWN * 200 * delta,ray.global_transform.origin - global_transform.origin)
	
	FloorRay.force_raycast_update()
	if FloorRay.is_colliding():
		apply_central_force(-FloorRay.transform.basis.y * gravity_force)
	else : 
		apply_torque(5*Vector3(-global_rotation.x,0,-global_rotation.z))
		apply_central_force(-Global.Track.transform.basis.y * gravity_force * 5)
	
	#======================================================================
	linear_velocity -= linear_velocity * 0.2
	var AB_axis : float  = Input.get_axis("brake","accelerate")
	var LR_axis : float = -Input.get_axis("steer_left","steer_right")
	var z_velocity : float =  linear_velocity.dot(-global_transform.basis.z)
	var sideways_velocity : float = linear_velocity.dot(global_transform.basis.x)
	var carVelocityRatio : float = abs(z_velocity)/max_speed
	var dragMagnitude : float = -sideways_velocity * dragCoefficient
	
	
	
	if AB_axis>0:
		apply_central_force(-global_transform.basis.z.normalized() * CC * delta)
	
	if AB_axis<0:
		apply_central_force(global_transform.basis.z.normalized() * CC * delta)
	
	apply_torque(delta * steer_angle * steer_strength * LR_axis * turnGraph.sample(carVelocityRatio) * sin(carVelocityRatio) * Vector3.UP)
	
	var dragForce = global_transform.basis.x * dragMagnitude
	apply_central_force(dragForce)
	update_model(steer_angle * LR_axis)
	
	
	

func update_model(angle : float):
	FR_wheel.rotation.y = deg_to_rad(angle)
	FL_wheel.rotation.y = deg_to_rad(angle)

func hitstun(duration : float)->void:
	#print(immune)
	if immune == false:
		#print("stunned")
		linear_velocity = Vector3.ZERO
		immune = true
	else : return
