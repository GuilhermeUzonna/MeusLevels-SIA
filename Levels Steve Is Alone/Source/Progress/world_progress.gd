extends Node
#var worlds_stats = {
	#"prologue" : {"coins" : [], "current_level" : 0},
	#"challenges" : {"coins" : [], "current_level" : 0}
#}

#func _ready() -> void:
	#var world_keys = worlds_stats.keys()
	#worlds_stats[world_keys[GLOBAL.current_level_index]]["coins"].append(GLOBAL.current_level_index)
	#print(worlds_stats)

var current_levels = []
var current_coins = []
var current_friends = []
var unlocked_worlds = []

var coins_indexes = []

#func _process(_delta: float) -> void:
	#print(GLOBAL.current_level_selection)
	#print("level_index: ", GLOBAL.current_level_index)
	#print("current_world_index: ", GLOBAL.current_world_index)
	#print("coins: ", current_coins)
	#print(unlocked_worlds)
