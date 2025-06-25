extends Node

class_name GameSaver

func save_game():
	var save_file = ConfigFile.new()
	save_file.set_value("config", "music_volume", CONFIG.music_volume)
	save_file.set_value("config", "sounds_volume", CONFIG.sounds_volume)
	save_file.set_value("config", "button_display", CONFIG.button_display)

	save_file.set_value("global", "current_level_selection", GLOBAL.current_level_selection)
	save_file.set_value("global", "current_menu_color", GLOBAL.current_menu_color)
	save_file.set_value("global", "current_menu_song", GLOBAL.current_menu_song)
	save_file.set_value("global", "friend_visit", GLOBAL.friend_visit)

	save_file.set_value("worldprogress", "current_coins", WORLDPROGRESS.current_coins)
	save_file.set_value("worldprogress", "current_levels", WORLDPROGRESS.current_levels)
	save_file.set_value("worldprogress", "current_friends", WORLDPROGRESS.current_friends)
	save_file.set_value("worldprogress", "unlocked_worlds", WORLDPROGRESS.unlocked_worlds)
	save_file.save("user://save.cfg")
