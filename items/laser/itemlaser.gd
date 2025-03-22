class_name ItemLaserResource
extends ItemResource

var laser : ShapeCast3D
var name : String = "Laser"

func use(itemManager : ItemManager):
	var player = itemManager.player
	laser = load("res://items/laser/laser.tscn").instantiate()
	laser.name = "Laser" + str(get_rid())
	laser.add_exception(player)
	itemManager.removeItem1(self)
	itemManager.activeItem.append(self)
	itemManager.add_child(laser)
	
	await itemManager.get_tree().create_timer(1).timeout
	
	itemManager.removeActiveItem(self)
	laser.queue_free()
	
	return

func update(itemManager : ItemManager, delta) :
	
	laser.update(delta)
