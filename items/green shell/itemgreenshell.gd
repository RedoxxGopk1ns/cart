class_name ItemGreenShellResource
extends ItemResource

var green_shell : CharacterBody3D
var name : String = "Green Shell"
func use(itemManager : ItemManager):
	var player : VehicleBody3D = itemManager.player
	green_shell = load("res://items/green shell/green_shell.tscn").instantiate()
	green_shell.Owner = itemManager.player
	
	green_shell.transform = player.transform
	green_shell.position = player.position - 2*player.transform.basis.z + Vector3(0,1,0)
	green_shell.position= Global.Track.to_local(green_shell.position)
	Global.Track.add_child(green_shell)
	itemManager.removeItem1(self)
	return
