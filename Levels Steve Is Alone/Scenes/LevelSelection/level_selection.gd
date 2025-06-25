@tool

extends Node2D

@export var levels_folder : String

var total_coins = 0

func _ready():
	if GLOBAL.level_completed:
		if GLOBAL.current_level_index == WORLDPROGRESS.current_levels[GLOBAL.current_world_index] and GLOBAL.current_level_index < self.get_child_count():
			WORLDPROGRESS.current_levels[GLOBAL.current_world_index] = GLOBAL.current_level_index + 1
		GLOBAL.level_completed = false

	if GLOBAL.coin_collected and not GLOBAL.current_level_index in WORLDPROGRESS.current_coins[GLOBAL.current_world_index]:
		WORLDPROGRESS.current_coins[GLOBAL.current_world_index].append(GLOBAL.current_level_index)
		GLOBAL.coin_collected = false

	if GLOBAL.friend_collected and not GLOBAL.current_world_index in WORLDPROGRESS.current_friends:
		get_parent().poem_notification()
		WORLDPROGRESS.current_friends[GLOBAL.current_world_index] = GLOBAL.current_world_index
		GLOBAL.friend_collected = false
		GLOBAL.friend_visit = true

	for i in range(1, self.get_child_count()):
		if i < WORLDPROGRESS.current_levels[GLOBAL.current_world_index]:
			get_child(i).set_completion(0)
		elif i == WORLDPROGRESS.current_levels[GLOBAL.current_world_index]:
			get_child(i).set_completion(1)
		else:
			get_child(i).set_completion(2)

		if (i -1) in WORLDPROGRESS.coins_indexes[GLOBAL.current_world_index]:
			get_child(i).has_coin()
		if i in WORLDPROGRESS.current_coins[GLOBAL.current_world_index]:
			get_child(i).collected()

	var game_saver = GameSaver.new()
	game_saver.save_game()

	update_line()
	if not Engine.is_editor_hint():
		set_process(false)

func get_poem():
	var poem = ""
	for i in range(1, self.get_child_count()):
		if i == 1:
			poem += self.get_child(i).title
		else:
			poem += "\n" + self.get_child(i).title
	return poem

func update_line():
	var line_points = []
	for i in range(1, self.get_child_count()):
		line_points.append(self.get_child(i).global_position + Vector2(1, 0))
	$Line2D.points = line_points

func select_level(child):
	GLOBAL.current_level_index = child.get_index()
	var path = levels_folder + "level_" + str(child.get_index()) + ".tscn"
	get_parent().go_to_level(path)

func _process(_delta):
	update_line()

func _get_configuration_warnings():
	var warnings = []
	if self.get_child_count() == 1:
		warnings.append("Esse node precisa de ao menos um filho 'level_selection_component' para funcionar.")
	return warnings
