extends Control

func _ready() -> void:
	var world_count = 0

	var world_info = WorldInfo.new()
	var new_coins_indexes = []
	for child in load("res://Scenes/UI/Menus/WorldSelection/world_selection.tscn").instantiate().get_node("HBoxContainer").get_children():
		new_coins_indexes.append(world_info.get_coins_index(child.folder_path))
		world_count += 1

	WORLDPROGRESS.coins_indexes = new_coins_indexes

	var config = ConfigFile.new()
	var err = config.load("user://save.cfg")

	if err != OK:
		for i in range(world_count):
			WORLDPROGRESS.current_coins.append([])
		WORLDPROGRESS.current_levels.resize(world_count)
		WORLDPROGRESS.current_levels.fill(1)
		WORLDPROGRESS.current_friends.resize(world_count)
		WORLDPROGRESS.current_friends.fill(null)
	else:
		load_save_file(config)
	MusicManager.update_volume()

func load_save_file(save_file):
	CONFIG.music_volume = save_file.get_value("config", "music_volume")
	CONFIG.sounds_volume = save_file.get_value("config", "sounds_volume")
	CONFIG.button_display = save_file.get_value("config", "button_display")

	GLOBAL.current_level_selection = save_file.get_value("global", "current_level_selection")
	GLOBAL.current_menu_color = save_file.get_value("global", "current_menu_color")
	GLOBAL.current_menu_song = save_file.get_value("global", "current_menu_song")
	GLOBAL.friend_visit = save_file.get_value("global", "friend_visit")

	WORLDPROGRESS.current_coins = save_file.get_value("worldprogress", "current_coins")
	WORLDPROGRESS.current_levels = save_file.get_value("worldprogress", "current_levels")
	WORLDPROGRESS.current_friends = save_file.get_value("worldprogress", "current_friends")
	WORLDPROGRESS.unlocked_worlds = save_file.get_value("worldprogress", "unlocked_worlds")

	var game_saver = GameSaver.new()
	game_saver.save_game()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "intro":
		MusicManager.transition_to(GLOBAL.current_menu_song)
		get_tree().change_scene_to_file("res://Source/Introduction/introduction.tscn")
