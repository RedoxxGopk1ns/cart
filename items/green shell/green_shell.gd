class_name GreenShell
extends CharacterBody3D


@onready var raycast : RayCast3D = $RayCast3D
var Owner : Player
var hit : int = 3 :
	set(v):
		if v == 0 :
			queue_free()
		else : hit = v

@export var speed : float = 20
func _ready() -> void:
	await get_tree().create_timer(10).timeout
	if !is_queued_for_deletion():
		queue_free()


func _physics_process(delta: float) -> void:
	#move_toward(transform.basis.z)
	
	if raycast.is_colliding():
		var p : Vector3 = raycast.get_collision_point()+Vector3(0,0.6,0)
		position.y = p.y
	else : 
		position.y -= 10 * delta
	var collision : KinematicCollision3D = move_and_collide(-transform.basis.z *delta*speed)
	if collision:
		#transform = transform.rotated(Vector3.UP,collision.get_angle())
		basis.z = basis.z.bounce(collision.get_normal())
		hit -= 1
		


func _on_area_3d_body_entered(body: Node3D) -> void:
	if (body is Player) and !is_queued_for_deletion():
		queue_free()
