extends RigidBody3D

var accelDir : Vector3 = transform.up
		if (accelInout>0.0):
			float carSpeed = Vector3.Dot(caTransform.forward, carRigidBody.velocity)
			
			float normalizedSpeed = Mathf.clamp01(mathf.abs(carspeed)/ carTopSpeed)
			
			float available torque = powerCurve.Evalutae((normalizedSpeed) *accelInout)
			
			plauyer.addForcePosition(accelDir * available torque, tireTransform.psition)
