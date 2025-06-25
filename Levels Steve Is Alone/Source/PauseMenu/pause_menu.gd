extends Control

var current_index = 0

func _ready() -> void:
	self.hide()

func pause():
	current_index = 0
	update_focus()
	self.show()
	get_tree().paused = true

func unpause():
	self.hide()
	get_tree().paused = false

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("esc") and GLOBAL.is_inside_level:
		if !self.visible:
			pause()
		else:
			unpause()
	if self.visible and $Menu.visible:
		if Input.is_action_just_pressed("move_down"):
			if current_index < $Menu.get_child_count() - 1:
				current_index += 1
			else:
				current_index = 0
			update_hover_down()
		if Input.is_action_just_pressed("move_up"):
			if current_index > 0:
				current_index -= 1
			else:
				current_index = $Menu.get_child_count() - 1
			update_hover_up()
		if Input.is_action_just_pressed("back"):
			unpause()
		if Input.is_action_just_pressed("jump"):
			$Menu.get_child(current_index).select()
		get_viewport().set_input_as_handled()

func update_focus():
	for child in $Menu.get_children():
		if child.get_index() != current_index:
			child.unfocus()
		else:
			child.focus()

func update_hover_down():
	for child in $Menu.get_children():
		if child.get_index() != current_index:
			child.unfocus()
		else:
			child.focus()
			child.hover_down()

func update_hover_up():
	for child in $Menu.get_children():
		if child.get_index() != current_index:
			child.unfocus()
		else:
			child.focus()
			child.hover_up()

func _on_resume_selected() -> void:
	await get_tree().create_timer(0.1).timeout
	unpause()

func _on_level_selection_selected() -> void:
	unpause()
	get_tree().change_scene_to_file(GLOBAL.current_level_selection)

func _on_options_selected() -> void:
	$Menu.hide()
	$Options.open()

func _on_options_closed() -> void:
	$Menu.show()

func _on_quit_selected() -> void:
	unpause()
	get_tree().change_scene_to_file("res://Scenes/UI/Menus/MainMenu/main_menu.tscn")
