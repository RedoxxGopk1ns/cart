extends Node

@onready var multiplayer_ui = $UI/Multiplayer
const PLAYER = preload("res://player/Player.tscn")
var peer = ENetMultiplayerPeer.new()


func _on_host_pressed() -> void:
	peer.create_server(25565)
	multiplayer.multiplayer_peer = peer
	
	multiplayer.peer_connected.connect(
		func(pid):
			print("Peer" + str(pid) + "has joined")
			add_player(pid)
	)
	add_player(multiplayer.get_unique_id())
	multiplayer_ui.hide()


func _on_join_pressed() -> void:
	peer.create_client("localhost",25565)
	multiplayer.multiplayer_peer = peer
	multiplayer_ui.hide()


func add_player(pid):
	var player = PLAYER.instantiate()
	player.name = str(pid)
	add_child(player)
