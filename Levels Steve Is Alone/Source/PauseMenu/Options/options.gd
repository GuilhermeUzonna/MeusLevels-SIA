extends VBoxContainer

signal closed

var current_index = 0

func _ready() -> void:
	self.hide()
	update_focus()

func pause():
	self.show()
	get_tree().paused = true

func unpause():
	self.hide()
	await get_tree().create_timer(0.05).timeout
	get_tree().paused = false

func open():
	current_index = 0
	self.visible = true
	update_focus()
	set_toggles()

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("esc") and GLOBAL.is_inside_level:
		if self.visible:
			close()
	if self.visible:
		if Input.is_action_just_pressed("move_down"):
			if current_index < self.get_child_count() - 1:
				current_index += 1
			else:
				current_index = 0
			update_hover_down()
		if Input.is_action_just_pressed("move_up"):
			if current_index > 0:
				current_index -= 1
			else:
				current_index = self.get_child_count() - 1
			update_hover_up()
		if Input.is_action_just_pressed("move_right"):
			get_child(current_index).add_value()
			update_toggles()
		if Input.is_action_just_pressed("move_left"):
			get_child(current_index).remove_value()
			update_toggles()
		if Input.is_action_just_pressed("back"):
			close()
		if Input.is_action_just_pressed("jump"):
			get_child(current_index).select()
		get_viewport().set_input_as_handled()

func update_focus():
	for child in self.get_children():
		if child.get_index() != current_index:
			child.unfocus()
		else:
			child.focus()

func update_hover_down():
	for child in self.get_children():
		if child.get_index() != current_index:
			child.unfocus()
		else:
			child.focus()
			child.hover_down()

func update_hover_up():
	for child in self.get_children():
		if child.get_index() != current_index:
			child.unfocus()
		else:
			child.focus()
			child.hover_up()

func set_toggles():
	var music_volume = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))
	var sound_volume = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Sounds"))
	$Music.set_value(db_to_linear(music_volume) * 10)
	$Sounds.set_value(db_to_linear(sound_volume) * 10)
	$Timer.set_value(SPEEDRUNTIMER.is_timer_visible)

func update_toggles():
	#AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db($Music.get_value() / 10))
	#AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sounds"), linear_to_db($Sounds.get_value() / 10))
	CONFIG.music_volume = $Music.get_value() / 10
	CONFIG.sounds_volume = $Sounds.get_value() / 10
	MusicManager.update_volume()
	SPEEDRUNTIMER.is_timer_visible = $Timer.get_value()

func close():
	self.hide()
	closed.emit()
	var game_saver = GameSaver.new()
	game_saver.save_game()

func _on_back_selected() -> void:
	close()
