extends Label

@export var IM : ItemManager
@export_range(1,2) var ItemNumber : int 
func _physics_process(delta: float) -> void:
	match ItemNumber : 
		
		1:
			if IM.item1:
				text = str(IM.item1.name)
			else : text = ""
		2:
			if IM.item2:
				text = str(IM.item2.name)
			else : text = ""
