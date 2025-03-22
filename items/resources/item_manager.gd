class_name ItemManager
extends Node3D

@onready var player = $".."
@export var item1 : ItemResource = null
@export var item2 : ItemResource = null
@export var activeItem : Array[ItemResource] = []

func _unhandled_input(event: InputEvent) -> void:
	#if !is_multiplayer_authority():
		#return
	if event is InputEventKey and event.is_action_pressed("use_item"):
		useItem()



func useItem():
	if item1 :
		item1.use(self)
	
	else : print("NO ITEMS")

func removeItem1(item : ItemResource):
	if item1 == item:
		item1=item2
		item2 = null

func removeActiveItem(item : ItemResource):
	activeItem.erase(item)

func update(delta):
	
	if !activeItem.is_empty():
		for i in (activeItem.size()):
			if activeItem[i]:
				activeItem[i].update(self,delta)
