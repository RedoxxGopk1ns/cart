class_name ItemGreenShellResource
extends ItemResource

var shell = preload("res://items/green shell/green_shell.tscn").instantiate()

func use(itemManager : ItemManager):
	var player = itemManager.player
	var car = itemManager.car
	
	#create shell independent
	#apply_central_force(-shell * speed_input)
	itemManager.activeItem.append(self)
	
	await itemManager.get_tree().create_timer(5).timeout
	
	itemManager.removeActiveItem(self)
	
	shell.queue_free()
	return

func update(itemManager : ItemManager, delta) :
	
	pass
