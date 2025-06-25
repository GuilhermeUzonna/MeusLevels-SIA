extends Node2D

var save_file_exists = false

func _ready() -> void:
	var config = ConfigFile.new()
	var err = config.load("user://save.cfg")

	if err == OK:
		save_file_exists = true

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("jump") and save_file_exists:
		get_tree().change_scene_to_file("res://Scenes/UI/Menus/MainMenu/main_menu.tscn")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "transition_out":
		get_tree().change_scene_to_file("res://Scenes/UI/Menus/MainMenu/main_menu.tscn")
