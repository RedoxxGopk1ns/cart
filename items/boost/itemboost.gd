class_name ItemBoostResource
extends ItemResource

@export var speed_percent : float = 50
@export var duration : float = 1

func use(itemManager : ItemManager):
	var player = itemManager.player
	var car = itemManager.car
	if itemManager.ray.is_colliding():
		player.apply_central_force(-car.global_transform.basis.z * speed_percent * player.acceleration)
	itemManager.activeItem = self
	await itemManager.get_tree().create_timer(1.5).timeout
	itemManager.removeActiveItem()
	return

func update(itemManager : ItemManager, delta) :
	itemManager.player.speed_input = speed_percent
