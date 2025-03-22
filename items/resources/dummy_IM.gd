
extends Node3D

@onready var player = $".."
@export var item1 : ItemResource = null
@export var item2 : ItemResource = null
@export var activeItem : Array[ItemResource] = []




func removeItem1(item : ItemResource):
	if item1 == item:
		item1=item2
		item2 = null

func removeActiveItem(item : ItemResource):
	activeItem.erase(item)
