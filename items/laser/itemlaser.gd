class_name ItemLaserResource
extends ItemResource


var laser = load("res://items/laser/laser.tscn").instantiate()


func use(itemManager : ItemManager):
	var player = itemManager.player
	var car = itemManager.car
	itemManager.removeItem1(self)
	laser.name = "Laser" + str(get_rid())
	
	itemManager.add_child(laser)
	
	return

func update(itemManager : ItemManager, delta) :
	
	#laser.force_shapecast_update()
	#if laser.is_colliding():
		#print("collided")
	#if end:
		#itemManager.removeActiveItem(self)
		#laser.queue_free()
	pass
