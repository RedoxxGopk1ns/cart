extends ShapeCast3D

var itemManager : ItemManager
var team


func update(delta: float) -> void:
	
	var obj 
	force_shapecast_update()
	if is_colliding():
		for i in get_collision_count():
			obj = get_collider(i)
			if obj is Player or Dummy:
				obj.hitstun(1)
				
