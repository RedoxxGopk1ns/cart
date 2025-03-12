extends ShapeCast3D

var itemManager : ItemManager
var team
func _ready() -> void:
	itemManager = get_parent()
	print(itemManager)
	await itemManager.get_tree().create_timer(1).timeout
	queue_free()

func _process(delta: float) -> void:
	force_shapecast_update()
	if is_colliding():
		print("collided")
