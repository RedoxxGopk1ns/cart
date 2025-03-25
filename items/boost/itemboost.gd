class_name ItemBoostResource
extends ItemResource

@export var speed_percent : float = 0.1
@export var duration : float = 1

var name : String = "Boost"

func use(itemManager : ItemManager):
	var player : Player = itemManager.player
	#player.apply_central_force(-player.global_transform.basis.z * speed_percent * player.CC)
	#player.set_linear_velocity(-player.global_transform.basis.z * speed_percent * player.CC * delta) 
	itemManager.activeItem.append(self)
	itemManager.removeItem1(self)
	await itemManager.get_tree().create_timer(1.5).timeout
	itemManager.removeActiveItem(self)
	return

func update(itemManager : ItemManager, delta) :
	var player: Player =itemManager.player
	
	player.set_linear_velocity(-player.transform.basis.z * speed_percent * player.CC * delta) 
	
