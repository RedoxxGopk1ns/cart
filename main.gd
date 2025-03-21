extends Node

var PlayerScene : PackedScene = preload("res://player/Player.tscn")
var LocalMultiWindowScene : PackedScene = preload("res://multiplayer/local_multi_window.tscn")

@export var current_track : Node3D

@onready var start_actions : Array = InputMap.get_actions()

var start_actions_events : Dictionary = {}
var players_in_game : Dictionary = {}
var prefix_action : String = "PL"

func _ready() -> void:
	
	init_inputmap()
	Input.connect("joy_connection_changed", _on_joy_connection_changed)
	

func _on_joy_connection_changed(device: int, connected: bool):
	var players = Input.get_connected_joypads()
	if connected:
		players_in_game[device] = (prefix_action + str(device))  #{0:PL0}
		add_player_inputmap(device)
	else:
		players_in_game.erase(device) #{0:PL0}


func init_inputmap():
	for action in start_actions:
		var events: Array = InputMap.action_get_events(action)
		var start_events: Array = events.map(func(i): return i.duplicate(true))
		start_actions_events[action] = start_events


func add_player_inputmap(device: int):
	for action in start_actions:
		var new_action: StringName = (action + prefix_action + str(device))
		if not InputMap.has_action(new_action):
			InputMap.add_action(new_action)
			
			# INFO: Duplicate InputEvents inside Array[InputEvent]
			var new_events: Array = start_actions_events[action].map(func(i): return i.duplicate(true))
			var new_actions_events: Dictionary = {}
			new_actions_events[new_action] = new_events
			
			# INFO: SET new_events to new_actions via dictionary keys
			for index in range(new_actions_events[new_action].size()):
				if new_actions_events[new_action][index] is not InputEventKey:
					new_actions_events[new_action][index].set_device(device)
					InputMap.action_add_event(new_action, new_actions_events[new_action][index])
	add_new_player(device)


# INFO: IF keyboard+Joypad - ERASE joy_button and joy_motion from start_actions 
func erase_joypad_events():
	for action in start_actions:
		for index in range(start_actions_events[action].size()):
			if start_actions_events[action][index] is not InputEventKey:
				InputMap.action_erase_event(action, start_actions_events[action][index])

func add_new_player(i : int)->void:
	var new_player : Player = PlayerScene.instantiate()
	new_player.player_id = i
	current_track.add_child(new_player)
	if i!=0:
		var new_window : LocalMultiWindow = LocalMultiWindowScene.instantiate()
		new_window.car = new_player
		add_child(new_window)
		new_window.Update()
		
