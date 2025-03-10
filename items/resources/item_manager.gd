class_name ItemManager
extends Node3D

@export var player : RigidBody3D
@export var car : Node3D
@export var ray : RayCast3D
@export var item1 : ItemResource = null
@export var item2 : ItemResource = null
@export var activeItem : ItemResource = null

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_action_pressed("use_item"):
		useItem()


func useItem():
	if item1 :
		item1.use(self)
		item1 = null
		if item2:
			item1=item2
			item2= null
	else : print("NO ITEMS")

func removeActiveItem():
	activeItem = null

func update(delta):
	
	if activeItem != null:
		activeItem.update(self,delta)
