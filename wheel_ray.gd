extends RayCast3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if is_colliding():
		
		#world direction of the spring force
		var springDir : Vector3 = Vector3.UP
		
		#world velocity of the tire
		var tireWorldVelocity : Vector3 = carRigidBody.getPointVelocity(tireTransform.position)
		
		#offset from the ray cast
		float offset = suspensionRestDist - ray hit.distance
		
		#
		float vel = Vector3.Dot(springDir, tireWorldVel)
		
		
		
		
