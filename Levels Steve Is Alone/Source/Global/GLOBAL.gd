extends Node

var current_input_type = "keyboard"

var current_level_index = 0
var current_world_index = 0
var last_level_selection = null
var position_in_level_selection = Vector2()

var current_level_selection = ""
var current_menu_color = Color("00d0ff")
var current_menu_song = "prologue"

var level_completed = false
var coin_collected = false
var friend_collected = false
var friend_visit = false

var is_inside_level = false

#func _process(_delta: float) -> void:
	#print(current_level_selection)

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		current_input_type = "keyboard"
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		current_input_type = "joystick"
