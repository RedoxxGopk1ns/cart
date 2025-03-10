class_name ItemBox
extends Area3D

@onready var shape : CollisionShape3D = $CollisionShape3D
@onready var mesh : MeshInstance3D = $CollisionShape3D/MeshInstance3D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(player: RigidBody3D) -> void:
	if player.itemManager.item1 == null :
		player.itemManager.item1 = ItemBoostResource.new()
		print("picked up boost 1")
	elif player.itemManager.item2 == null:
		player.itemManager.item2 = ItemBoostResource.new()
		print("picked up boost 2")
		
	
	mesh.visible = false
	set_deferred("monitoring",false)
	set_deferred("monitored",false)
	
	await get_tree().create_timer(5).timeout
	
	mesh.visible = true
	set_deferred("monitoring",true)
	set_deferred("monitored",false)
