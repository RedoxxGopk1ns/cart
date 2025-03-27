class_name Lepra
extends RigidBody3D


@export var player_id : int = -1
@export var CC = 200
@export var Accelaration =  200
@export var steer_angle =  30
@export var brake_power = 300
@export var slip : float = 0.5
@export var suspension_force : float = 40

@onready var camera : Camera3D = $Camera3D
@onready var itemManager : ItemManager 
@onready var FR_wheel : MeshInstance3D = $FR
@onready var FL_wheel : MeshInstance3D = $FL
@onready var Body_Mesh : MeshInstance3D = $body/body2
@onready var rays : Array = get_tree().get_nodes_in_group("Raycasts")

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
	#axis_lock_angular_x = true


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
			print(dist)
		#apply my own central force as  gravity when the car isnt on the groyund
		#lerp:correcting rotation force as a function of the angle difference of world vector_down and the vehicles rotation
		#else : apply_force(Vector3.DOWN * 200 * delta,ray.global_transform.origin - global_transform.origin)
	#======================================================================
	linear_velocity -= linear_velocity * 0.2
	var AB_axis : float  = Input.get_axis("brake","accelerate")
	var LR_axis : float = -Input.get_axis("steer_left","steer_right")
	var z_velocity : float =  linear_velocity.dot(-global_transform.basis.z)
	var x_velocity : float = linear_velocity.dot(global_transform.basis.x)
	
	#z_velocity = velocity.project(-global_transform.basis.z).length()
	if AB_axis>0:
		linear_velocity -= FR_wheel.global_transform.basis.z.normalized() * CC * delta
		
	if AB_axis<0:
		linear_velocity += FR_wheel.global_transform.basis.z.normalized() * CC * delta
	
	
	if abs(z_velocity) > 0.1 :
		rotate(global_transform.basis.y.normalized(), delta * steer_angle * LR_axis/(2.2 * z_velocity))
	update_model(steer_angle * LR_axis)
	
	linear_velocity-=global_transform.basis.x * x_velocity * slip
	#collided = move_and_slide()
	

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
