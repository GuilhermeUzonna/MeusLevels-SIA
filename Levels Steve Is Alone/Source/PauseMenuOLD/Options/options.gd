extends VBoxContainer

signal closed

var current_index = 0

func _ready() -> void:
	update_focus()
	set_audio_and_sounds()

func _physics_process(_delta: float) -> void:
	if self.visible:
		if Input.is_action_just_pressed("jump"):
			self.get_child(current_index).select()
		if Input.is_action_just_pressed("move_down"):
			if current_index < (self.get_child_count() - 1):
				current_index += 1
				update_selection()
		if Input.is_action_just_pressed("move_up"):
			if current_index > 0:
				current_index -= 1
				update_selection()
		if Input.is_action_just_pressed("move_right"):
			if get_child(current_index).has_method("add_value"):
				get_child(current_index).add_value(1)
				update_music_bus()
				update_sounds_bus()
		if Input.is_action_just_pressed("move_left"):
			if get_child(current_index).has_method("remove_value"):
				get_child(current_index).remove_value(1)
				update_music_bus()
				update_sounds_bus()
		if Input.is_action_just_pressed("back"):
			close()

func update_focus():
	for child in self.get_children():
		if child.get_index() == current_index:
			child.focus()
		else:
			child.unfocus()

func update_selection():
	for child in self.get_children():
		if child.get_index() == current_index:
			child.hover()
		else:
			child.unhover()

func update_music_bus():
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db($Music.get_value() / 10))

func update_sounds_bus():
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sounds"), linear_to_db($Sounds.get_value() / 10))

func _on_visibility_changed() -> void:
	if self.visible:
		current_index = 0
		update_focus()
		set_audio_and_sounds()

func _on_back_selected() -> void:
	close()

func close():
	closed.emit()
	self.hide()

func set_audio_and_sounds():
	var music_volume = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))
	var sound_volume = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Sounds"))
	$Music.set_value(db_to_linear(music_volume) * 10)
	$Sounds.set_value(db_to_linear(sound_volume) * 10)
