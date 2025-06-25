extends Node2D

var selected_level

func _ready():
	if $PoemSign.show_poem and WORLDPROGRESS.current_levels[GLOBAL.current_world_index] >= $LevelSelection.get_child_count():
		$PoemSign.show()
		$PoemSign.set_poem($LevelSelection.get_poem())
	else:
		$PoemSign.hide()
	$CoinAmount/Label.text = str(WORLDPROGRESS.current_coins[GLOBAL.current_world_index].size()) + "/" + str(WORLDPROGRESS.coins_indexes[GLOBAL.current_world_index].size())
	GLOBAL.is_inside_level = false
	if !PauseMenu.visible:
		get_tree().paused = false

	if GLOBAL.last_level_selection != self.get_scene_file_path():
		GLOBAL.position_in_level_selection = Vector2()
	
	if GLOBAL.position_in_level_selection != Vector2():
		$Cursor.global_position = GLOBAL.position_in_level_selection
	else:
		$Cursor.global_position = Vector2($LevelSelection.get_child(1).global_position.x - 16, $LevelSelection.get_child(1).global_position.y)
	GLOBAL.last_level_selection = self.get_scene_file_path()

func poem_notification():
	if get_node_or_null("PoemSign") != null:
		get_node_or_null("PoemSign").show_notification()

func _physics_process(_delta):
	if Input.is_action_pressed("back"):
		selected_level = "res://Scenes/UI/Menus/WorldSelection/world_selection.tscn"
		$AnimationPlayer.play("transition_out")

func go_to_level(level_path : String):
	selected_level = level_path
	$AnimationPlayer.play("transition_out")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "transition_out":
		GLOBAL.position_in_level_selection = $Cursor.global_position
		get_tree().change_scene_to_file(selected_level)
