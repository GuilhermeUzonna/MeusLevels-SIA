extends Control

var current_index = 0

var next_scene = null

var coin_amount = 0

var is_unlocking = false

func _ready():
	coin_amount = 0
	for array in WORLDPROGRESS.current_coins:
		for element in array:
			coin_amount += 1
	var total_coin_count = 0
	for element in WORLDPROGRESS.coins_indexes:
		total_coin_count += element.size()
	$Camera2D/HBoxContainer/Label.text = str(coin_amount) + "/" + str(total_coin_count)

	set_process(false)
	for child in $HBoxContainer.get_children():
		child.set_coin_progress(coin_amount)
		if child.get_index() in WORLDPROGRESS.unlocked_worlds:
			child.set_unlocked()
		if child.world_path == GLOBAL.current_level_selection:
			current_index = child.get_index()
	update_cells(current_index)
	$Camera2D.global_position.x = 155 + 128 * (current_index)
	$Background.color = $HBoxContainer.get_child(current_index).world_color
	await get_tree().create_timer(0.1).timeout
	set_process(true)

func _physics_process(_delta):
	if !$AnimationPlayer.current_animation == "transition_out" and !is_unlocking:
		if Input.is_action_just_pressed("jump"):
			$HBoxContainer.get_child(current_index).select()
			if !$HBoxContainer.get_child(current_index).locked:
				GLOBAL.current_world_index = current_index
				next_scene = $HBoxContainer.get_child(current_index).world_path
				transition_to(next_scene)

		if Input.is_action_just_pressed("move_right"):
			if current_index < $HBoxContainer.get_child_count() - 1:
				current_index += 1
			else:
				current_index = 0
			update_cells(1)
			update_lock()

		if Input.is_action_just_pressed("move_left"):
			if current_index > 0:
				current_index -= 1
			else:
				current_index = $HBoxContainer.get_child_count() - 1
			update_cells(0)
			update_lock()

		if Input.is_action_just_pressed("back"):
			transition_to("res://Scenes/UI/Menus/MainMenu/main_menu.tscn")

func update_lock():
	if !$HBoxContainer.get_child(current_index).locked:
		GLOBAL.current_menu_song = $HBoxContainer.get_child(current_index).song
	else:
		if coin_amount >= $HBoxContainer.get_child(current_index).price:
			if not current_index in WORLDPROGRESS.unlocked_worlds:
				WORLDPROGRESS.unlocked_worlds.append(current_index)
			GLOBAL.current_level_selection = $HBoxContainer.get_child(current_index).world_path
			$HBoxContainer.get_child(current_index).unlock()
			is_unlocking = true
			await $HBoxContainer.get_child(current_index).finished_unlocking
			is_unlocking = false
			print("chegou dps do await")

func _process(_delta: float) -> void:
	$Camera2D.global_position.x = lerp($Camera2D.global_position.x, $HBoxContainer.get_child(current_index).global_position.x + $HBoxContainer.get_child(current_index).get_rect().size.x/2, 0.1)
	if $Camera2D.global_position.x < 160:
		$Camera2D.global_position.x = 160
	if $Camera2D.global_position.x > $Background.get_rect().size.x - 160:
		$Camera2D.global_position.x = $Background.get_rect().size.x - 160

func update_cells(direction):
	for i in range($HBoxContainer.get_child_count()):
		if i == current_index:
			$HBoxContainer.get_child(i).hover(direction)
		else:
			$HBoxContainer.get_child(i).unhover()

	var tween = get_tree().create_tween()
	tween.tween_property($Background, "color", $HBoxContainer.get_child(current_index).world_color, 1)
	if MusicManager.current_key != $HBoxContainer.get_child(current_index).song:
		MusicManager.transition_to($HBoxContainer.get_child(current_index).song)
	if !$HBoxContainer.get_child(current_index).locked:
		GLOBAL.current_level_selection = $HBoxContainer.get_child(current_index).world_path
		GLOBAL.current_menu_color = $HBoxContainer.get_child(current_index).world_color

func transition_to(path : String):
	next_scene = path
	$AnimationPlayer.play("transition_out")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "transition_out":
		get_tree().change_scene_to_file(next_scene)
