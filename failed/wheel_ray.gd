extends RayCast3D
#Force = (Offset * Strength) - (Velocity * Damping)

@export var carRigidBody : RigidBody3D
@export var suspensionRestDist : float = 0.6
@export var Strength : float = 150.0
@export var stiffness : float = 0.7
@export var Damping : float = 2.0 
@export var Height: float = 0.4
@export var Tire : Node3D

var apply_force = Vector3() # this gets sent to the parent Vehicle_Main script
var displacement = 0.0
var prev_displacement = 0.0
var speed = 0.0
var wheel_vel_vector
@onready var car_p = get_parent()

@export var wheel_radius : float = 0.35
@export var spring_stiffness_curve: Curve
var spring_distance_max_in: float
var spring_distance_max_out: float
var spring_constant: float
var spring_damping: float
var force: Vector3
var offset: Vector3
var spring_distance: float
var spring_distance_now: float
var spring_force: float
var spring_rest_position: float
var wheel_position: Vector3
var spring_velocity: float
var circumference: float
var camber_rotation: Quaternion
var steering_rotation: Quaternion
var wanted_steering_rotation: Quaternion



func _physics_process(delta: float) -> void:
	#Force = (Offset * Strength) - (Velocity * Damping)
	#print(carRigidBody.linear_velocity)
	if is_colliding():
		
		prev_displacement = displacement
		
		displacement = (target_position - (get_collision_point()) * global_transform).length()
		speed = (displacement - prev_displacement) / delta
		
		var spring_force = car_p.gravity_scale * car_p.mass * stiffness * displacement
		var sus_damp_force = Damping * speed
		apply_force = Vector3.UP * clamp(spring_force + sus_damp_force, 0, 50)
	else:
		apply_force = Vector3.ZERO
		
	
	

func add_spring_force(delta: float, vehicle_body: RigidBody3D, anti_roll_force: float, vehicle_rotation: Quaternion) -> bool:
	var has_contact: bool = is_colliding()
	var stiffness_factor: float = 1
	if has_contact:
		var contact_point: Vector3 = get_collision_point()
		var contact_point_vehicle: Vector3 = carRigidBody.to_local(contact_point)
		spring_distance_now = contact_point_vehicle.y + wheel_radius
		spring_velocity = (spring_distance_now - spring_distance) / delta
		spring_distance = spring_distance_now
		if spring_distance > 0:
			var arg: float = spring_distance / spring_distance_max_in
			stiffness_factor = spring_stiffness_curve.sample(arg)
		spring_force = stiffness_factor * spring_constant * (spring_distance + spring_rest_position) # Hooke's Law
		spring_force += anti_roll_force
		var damping_force: float = spring_damping * spring_velocity
		force = Vector3(0, spring_force + damping_force, 0)
		offset = vehicle_rotation * contact_point_vehicle
		vehicle_body.apply_force(force, offset)
		wheel_position = Vector3(0, spring_distance, 0)
	else:
		spring_distance = 0
		wheel_position = Vector3(0, -spring_distance_max_out, 0)
	#wheel.transform.origin = wheel_position
	return has_contact

func get_point_velocity (body :RigidBody3D,point :Vector3)->Vector3:
	return body.linear_velocity + body.angular_velocity.cross(point - global_transform.origin)
