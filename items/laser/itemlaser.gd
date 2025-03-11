class_name ItemLaserResource
extends ItemResource

@export var length : float = 2
@export var duration : float = 1
var laser = load("res://items/laser/laser.tscn").instantiate()
var end : bool = false

func use(itemManager : ItemManager):
	var player = itemManager.player
	var car = itemManager.car
	
	itemManager.add_child(laser)
	itemManager.activeItem.append(self)
	
	await itemManager.get_tree().create_timer(1).timeout
	end = true
	
	return

func update(itemManager : ItemManager, delta) :
	
	laser.force_shapecast_update()
	if laser.is_colliding():
		print("collided")
	if end:
		itemManager.removeActiveItem(self)
		laser.queue_free()
