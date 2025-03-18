extends RigidBody3D

var sphere_offset = Vector3.DOWN
var acceleration = 35.0
var steering = 19.0
var turn_speed = 4.0
var turn_stop_limit = 0.75
var body_tilt = 35

var speed_input = 0
var turn_input = 0
var clamp_speed : float = 60

@onready var body : Node3D = $Body
@onready var mesh : Node3D = $Body/Mesh
@onready var ground_ray = $Body/GroundRay
@onready var right_wheel = $Body/Mesh/wheel_frontRight
@onready var left_wheel = $Body/Mesh/wheel_frontLeft
@onready var itemManager = $Body/ItemManager
@onready var ball = $CollisionShape3D
#@onready var hitbox = $Hitbox

#func _enter_tree() -> void:
	#set_multiplayer_authority(int(str(name)))
	#
func _ready() -> void:
	ground_ray.add_exception(self)

func _physics_process(delta):
	#if !is_multiplayer_authority():
		#return
	
	#hitbox.position = car_mesh.position
	itemManager.update(delta)
	body.position = position + sphere_offset
	
	if ground_ray.is_colliding() :
		apply_central_force(-body.global_transform.basis.z * speed_input)
		
		#linear_velocity.limit_length(1)
		#print(linear_velocity)


func _process(delta):
	#if !is_multiplayer_authority():
		#return
	
	if not ground_ray.is_colliding():
		return
	speed_input = Input.get_axis("brake", "accelerate") * acceleration
	turn_input = Input.get_axis("steer_right", "steer_left") * deg_to_rad(steering)
	right_wheel.rotation.y = turn_input
	left_wheel.rotation.y = turn_input
	
	
	if linear_velocity.length() > turn_stop_limit:
		var new_basis = body.global_transform.basis.rotated(body.global_transform.basis.y, turn_input)
		body.global_transform.basis = body.global_transform.basis.slerp(new_basis, turn_speed * delta)
		body.global_transform = body.global_transform.orthonormalized()
		var t = -turn_input * linear_velocity.length() / body_tilt
		mesh.rotation.z = lerp(mesh.rotation.z, t, 5.0 * delta)
		if ground_ray.is_colliding():
			var n = ground_ray.get_collision_normal()
			var xform = align_with_y(body.global_transform, n)
			body.global_transform = body.global_transform.interpolate_with(xform, 10.0 * delta)

func align_with_y(xform, new_y):
	xform.basis.y = new_y
	xform.basis.x = -xform.basis.z.cross(new_y)
#	xform.basis = xform.basis.orthonormalized()
	return xform.orthonormalized()
