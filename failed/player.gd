extends RigidBody3D

@export var speed = 15 #the speed of the car

# SUSPENSION PARAMETERS
@export var sus_force: float = 150.0 # the force the susp outputs
@export var sus_stiffness: float = 0.7 # how stiff susp is
@export var sus_damp: float = 2.0 # dampens the susp movement to decreas bounciness
@export var sus_height: float = 0.7 # how height the spring rises
#PHYSICS PARAM
@export var hfriction: float = 0.035 # the amount of friction on the wheel - this determines how quick the car stops during drift/when you hit the brakes
@export var turn_speed: float = 0.095 # how quickly the wheels respond to steering
# INPUT VARIABLES
var inp_forward = 0.0
var inp_steer = 0.0
var inp_break

# MISC
var facing = Vector3.FORWARD
var float_facing = 0.0
# ^ which direction the car is facing. Determined by projecting its 
# velocity onto the z axis. 
# Car is moving forward => facing forward, float_facing = 1 and the opposite. 
# This is necessary to invert the steering when going backwards as well as other things

# in radians, how much the steering wheels are currently rotated
var turn = 0.0

# These arrays contain the lists of all suspension spring nodes + all wheel collision nodes to quickly cycle through
@onready var wheels = [$RayFrontRight,$RayFrontLeft,$RayRearRight,$RayRearLeft]
#@onready var wheel_coll = [$Wheel_Coll_1, $Wheel_Coll_2, $Wheel_Coll_3, $Wheel_Coll_4]

func _process(delta):
	get_input()
	
	#for i in 2:
		#wheel_coll[i].rotation.y = turn

func get_input():
	inp_forward = Input.get_axis("ui_up", "ui_down")
	inp_steer = Input.get_axis("ui_right", "ui_left")
	inp_break = Input.is_action_pressed("inp_brake")
	
	turn = lerp(turn, PI/8 * inp_steer, turn_speed)

	facing = get_velocity().normalized()
	float_facing = -transform.basis.z.dot(facing)


func _physics_process(delta):
	for i in wheels.size():
		var hold_force = wheels[i].apply_force * sus_force
		apply_force(wheels[i].position, global_transform.basis * (hold_force * delta))
		
		if wheels[i].is_colliding():
			apply_impulse(transform.basis.z * inp_forward * speed * delta * wheels[i].get_type(), wheels[i].get_pos())
			
			apply_impulse(-transform.basis.x * wheels[i].get_frict_mod()[0] * hfriction, wheels[i].get_pos())
		
			if inp_break:
				apply_impulse(transform.basis.z * wheels[i].get_frict_mod()[1] * hfriction, wheels[i].get_pos())


func get_velocity(leng = false):
	if leng:
		return linear_velocity.project(transform.basis.z).length() * -float_facing
	else:
		return linear_velocity.project(transform.basis.z)
