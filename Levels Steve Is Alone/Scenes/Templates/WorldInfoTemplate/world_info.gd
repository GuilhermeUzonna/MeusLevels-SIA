extends Resource

class_name WorldInfo

#@export var levels_folder_path : String

func get_total_coin_count(levels_folder_path):
	var coin_count = 0

	var dir = DirAccess.open(levels_folder_path)
	if dir:
		var level_count = 0
		var file_names = dir.get_files()
		for i in range(file_names.size()):
			if ".tscn" in file_names[i]:
				level_count += 1

		var level_paths = []
		for i in range(level_count):
			level_paths.append("level_" + str(i + 1) + ".tscn")
		
		for path in level_paths:
			if load(levels_folder_path + path).instantiate().get_node_or_null("Coin") != null:
				coin_count += 1
	return coin_count

func get_coins_index(levels_folder_path):
	var coins_index = []

	var dir = DirAccess.open(levels_folder_path)
	if dir:
		var level_count = 0
		var file_names = dir.get_files()
		for i in range(file_names.size()):
			if ".tscn" in file_names[i]:
				level_count += 1

		var level_paths = []
		for i in range(level_count):
			level_paths.append("level_" + str(i + 1) + ".tscn")

		for i in range(level_paths.size() - 1):
			if load(levels_folder_path + level_paths[i]).instantiate().get_node_or_null("Coin") != null:
				coins_index.append(i)
	return coins_index
