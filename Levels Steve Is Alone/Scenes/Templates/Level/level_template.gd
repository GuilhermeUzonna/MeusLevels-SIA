@tool

extends Node2D

func _ready() -> void:
	GLOBAL.is_inside_level = true
	if !Engine.is_editor_hint():
		$Shader.size = $BackgroundColor.size

func end_level():
	GLOBAL.is_inside_level = false
	get_tree().paused = true
	$GameCamera.transition_out()
	if get_node_or_null("Coin") != null:
		get_node("Coin").picked_up()

func _on_game_camera_end_of_transition():
	get_tree().change_scene_to_file(GLOBAL.current_level_selection)
