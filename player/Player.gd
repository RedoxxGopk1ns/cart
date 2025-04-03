class_name Player
extends RigidBody3D

@export_group("Speed")
@export var CC = 5*1000
@export var max_speed : float = 50
@export var torque_curve : Curve
@export var boost_color : Color = Color(1,1,1)

@export_group("Steering")
@export var steer_angle : float =  30
@export var slip : float = 0.5
@export var turnGraph : Curve
@export var steer_strength : float = 60

@export_group("Drifting")
@export var drift_force : float =  50
@export var drift_torque: float = 0.1
@export var drift_jump_torque: float = 1.5
@export var drift_jump_force: float = 300
@export_subgroup("Tubro 1")
@export var turbo_time_1 : float = 1
@export var turbo_boost_1 : float = 0.6
@export var turbo_duration_1 : float = 0.8
@export var turbo_color_1 : Color = Color(1, 1, 1)
@export_subgroup("Tubro 2")
@export var turbo_time_2 : float = 2.6
@export var turbo_boost_2 : float = 0.7
@export var turbo_duration_2 : float = 2
@export var turbo_color_2 : Color = Color(0, 0.702, 0.694, 0.992)
@export_subgroup("Tubro 3")
@export var turbo_time_3 : float = 4
@export var turbo_boost_3 : float = 0.7
@export var turbo_duration_3 : float = 3
@export var turbo_color_3 : Color = Color(0.749, 0.02, 0.408)

@export_group("Suspension")
@export var suspension_force : float = 90
@export var gravity_force : float = 20
@export var rays : Array[RayCast3D]

@export_group("Debugging")
@export var player_id : int = -1



@onready var camera : Camera3D = $Camera3D
@onready var itemManager : ItemManager = $ItemManager
@onready var FR_wheel : Node3D = $CollisionShape3D/VisualRoot/VisualTires/VisualTireFR
@onready var FL_wheel : Node3D = $CollisionShape3D/VisualRoot/VisualTires/VisualTireFL
@onready var BR_mesh : Node3D = $CollisionShape3D/VisualRoot/VisualTires/VisualTireBR/BR_Tire_Mesh
@onready var BL_mesh : Node3D = $CollisionShape3D/VisualRoot/VisualTires/VisualTireBL/BL_Tire_Mesh
@onready var FR_mesh : MeshInstance3D = $CollisionShape3D/VisualRoot/VisualTires/VisualTireFR/FR_Tire_Mesh
@onready var FL_mesh : MeshInstance3D =$CollisionShape3D/VisualRoot/VisualTires/VisualTireFL/FL_Tire_Mesh
@onready var BL_particles : GPUParticles3D =$CollisionShape3D/VisualRoot/VisualTires/VisualTireBL/DriftParticlesL
@onready var BR_particles : GPUParticles3D =$CollisionShape3D/VisualRoot/VisualTires/VisualTireBR/DriftParticlesR
@onready var Front_Axle : Node3D = $FrontAxle
@onready var FloorRay : RayCast3D = $FloorRay
@onready var R_boost_particles : GPUParticles3D =$BoostParticlesR
@onready var L_boost_particles : GPUParticles3D =$BoostParticlesL

#--Buttons
var buttons : Dictionary
var brake_button : String
var accelerate_button : String
var steer_right_button : String
var steer_left_button : String
var use_item_button : String
var drift_button : String
#--
enum drift_state{LEFT=-1,NOT_DRIFTING=0,RIGHT=1}
var no_color : Color = Color(1,1,1)


var immune : bool = false :
	set(value):
		if value == true :
			immune = true
			await itemManager.get_tree().create_timer(2).timeout
			immune = false

func set_input_id(i : int) -> void:
	player_id = i
	brake_button = "brakePL" + str(i)
	accelerate_button = "acceleratePL" + str(i)
	steer_right_button = "steer_rightPL" + str(i)
	steer_left_button = "steer_leftPL" + str(i)
	use_item_button = "use_itemPL" + str(i)
	drift_button = "driftPL" + str(i)

var z_velocity : float = 0
var sideways_velocity : float = 0
var AB_axis : float = 0
var LR_axis : float = 0
var carVelocityRatio : float = 0

func _physics_process(delta: float) -> void:
	AB_axis = Input.get_axis(brake_button,accelerate_button)
	LR_axis = -Input.get_axis(steer_left_button,steer_right_button)
	z_velocity =  linear_velocity.dot(-global_transform.basis.z)
	carVelocityRatio = abs(z_velocity)/max_speed
	sideways_velocity = linear_velocity.dot(global_transform.basis.x)
	#--Drag
	#linear_velocity -= linear_velocity * 0.05
	
	suspension(delta)
	gravity(delta)
	drift(delta)
	engine(delta)
	steering(delta)
	update_model(steer_angle * LR_axis,delta)
	itemManager.update(delta)
	
	#if Input.is_action_pressed("debug_button"):
		#hitstun(1)

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	for i in get_colliding_bodies():
		

var ray_count : int = 0

func suspension(delta:float)->void:
	ray_count = 0
	for ray : RayCast3D in rays:
		ray.force_raycast_update()
		
		if ray.is_colliding():
			var collision_point = ray.get_collision_point()
			var dist = collision_point.distance_to(ray.global_transform.origin)
			apply_force(Vector3.UP * (1/dist) * suspension_force * delta,ray.global_transform.origin - global_transform.origin)
			ray_count+=1

var is_on_floor : bool = false

func gravity(delta : float)->void:
	FloorRay.force_raycast_update()
	if FloorRay.is_colliding():
		apply_central_force(-FloorRay.transform.basis.y * gravity_force)
		is_on_floor= true
	else : 
		apply_torque(6*Vector3(-global_rotation.x,-global_rotation.y * 0.1,-global_rotation.z))
		if abs(global_rotation.x) < 70 or abs(global_rotation.z) < 70:
			apply_central_force(-Global.Track.transform.basis.y * gravity_force * 2)
		is_on_floor = false

func engine(delta : float)->void:
	var torque_modifier: float = 1
	if drifting == true:
		torque_modifier = 0.85
	
	if is_on_floor:
		apply_central_force(-global_transform.basis.z.normalized() * CC * delta * AB_axis * torque_curve.sample(carVelocityRatio) * torque_modifier)

func steering(delta : float)->void:
	var steering_modifier : float = 1
	if drifting == true && drift_dir!=drift_state.NOT_DRIFTING:
		steering_modifier -=0.7
	
	#--Steering
	apply_torque(sign(AB_axis) * steering_modifier * delta * steer_strength * steer_angle * LR_axis * turnGraph.sample(carVelocityRatio) * sin(carVelocityRatio) * Vector3.UP)
	#if drifting == true && ray_count >=3:
		#apply_central_force(driftForce)

var drift_dir : int = drift_state.NOT_DRIFTING
var drifting : bool = false
var drift_time : float = 0

func drift(delta : float)->void:
	var but : bool = Input.is_action_pressed(drift_button)
	
	#hop
	if but && !drifting && ray_count==4:
		BR_particles.process_material.color = turbo_color_1
		BL_particles.process_material.color = turbo_color_1
		BR_particles.emitting=false
		BL_particles.emitting=false
		apply_central_force(global_transform.basis.y * drift_jump_force)
		drifting = true
		drift_time =0
		return
	#turn
	if but && drifting && drift_dir == drift_state.NOT_DRIFTING:
		BR_particles.process_material.color = turbo_color_1
		BL_particles.process_material.color = turbo_color_1
		BR_particles.emitting=false
		BL_particles.emitting=false
		if LR_axis == 0:
			drifting = false
			return
		if LR_axis > 0 :
			apply_torque(delta * steer_strength * steer_angle * drift_jump_torque * Vector3.UP)
			drift_dir = drift_state.RIGHT
			return
		if LR_axis < 0 :
			apply_torque(delta * steer_strength * steer_angle * -drift_jump_torque * Vector3.UP)
			drift_dir = drift_state.LEFT
			return
		return
	#force
	if but && drift_dir != drift_state.NOT_DRIFTING && ray_count>=3:
		apply_central_force(global_transform.basis.x * drift_force * drift_dir)
		apply_torque(delta * steer_strength * steer_angle * drift_torque * drift_dir * Vector3.UP)
		
		drift_time +=delta
		
		BR_particles.emitting=true
		BL_particles.emitting=true
		if drift_time>=turbo_time_3:
			
			BR_particles.process_material.color = turbo_color_3
			
		elif drift_time>=turbo_time_2:
			
			BR_particles.process_material.color = turbo_color_2
			
		return
	
	#turbo
	if !but && drift_dir != drift_state.NOT_DRIFTING:
		BR_particles.process_material.color = turbo_color_1
		BL_particles.process_material.color = turbo_color_1
		BR_particles.emitting=false
		BL_particles.emitting=false
		var turbo_mod:float=0
		var turbo_time : float = 0
		if drift_time>=turbo_time_3:
			turbo_time= turbo_duration_3
			turbo_mod = turbo_boost_3
		elif drift_time>=turbo_time_2:
			turbo_time= turbo_duration_2
			turbo_mod = turbo_boost_2
		elif drift_time>=turbo_time_1:
			turbo_time= turbo_duration_1
			turbo_mod = turbo_boost_1
		
		
		apply_central_force(-global_transform.basis.z.normalized() * CC * turbo_mod * delta)
		apply_central_force_forward_for_duration(turbo_time,CC * turbo_mod * delta,true,boost_color)
		drifting = false
		drift_dir = drift_state.NOT_DRIFTING
		drift_time =0
		return

func update_model(angle : float,delta:float):
	var rot:float = deg_to_rad(get_rot(delta))
	var mod : float = 1
	
	FR_wheel.rotation.y = deg_to_rad(angle)
	FL_wheel.rotation.y = deg_to_rad(angle)
	FR_mesh.rotate_x(rot)
	FL_mesh.rotate_x(rot)
	
	if drifting:
		mod = 3
	
	BR_mesh.rotate_x(rot*mod)
	BL_mesh.rotate_x(rot*mod)

func hitstun(duration : float)->void:
	#print(immune)
	if immune == false:
		#print("stunned")
		linear_velocity = Vector3.ZERO
		immune = true
	else : return

func apply_central_force_forward_for_duration(duration :float , force :float, particles :bool, color :Color):
	var start_time = Time.get_ticks_msec()
	if particles:
		R_boost_particles.process_material.color = color
		L_boost_particles.process_material.color = color
		R_boost_particles.emitting = true
		L_boost_particles.emitting = true
	while Time.get_ticks_msec() - start_time < duration * 1000:
		
		apply_central_force(force * -global_transform.basis.z.normalized())
		await get_tree().physics_frame  # Wait for the next frame
	R_boost_particles.emitting = false
	L_boost_particles.emitting = false

func apply_central_force_for_duration(duration : float , force : Vector3):
	var start_time = Time.get_ticks_msec()
	while Time.get_ticks_msec() - start_time < duration * 1000:
		
		apply_central_force(force)
		await get_tree().physics_frame  # Wait for the next frame

func get_rot(delta):
	var r = 0.25
	var rotation = (z_velocity / r) * 2 * PI * delta
	var rotate_amount: float
	
	if z_velocity <= 0:
		rotate_amount = -abs(rotation)
		return rotate_amount
	rotate_amount = abs(rotation)
	return rotate_amount
