class_name LocalMultiWindow
extends Window

@export var car : Player

# Called when the node enters the scene tree for the first time.
func Update() -> void:
	RenderingServer.viewport_attach_camera(get_viewport_rid(), car.camera.get_camera_rid())
