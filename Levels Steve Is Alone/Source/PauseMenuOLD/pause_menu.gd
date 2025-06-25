extends Control

var current_index = 0
var current_options_index = 0

func _ready():
	self.hide()
	$Menu.hide()

func pause():
	self.show()
	$Menu.show()
	get_tree().paused = true

func unpause():
	self.hide()
	await get_tree().create_timer(0.1).timeout
	get_tree().paused = false

#func _input(event: InputEvent) -> void:
	#pass

func _physics_process(_delta):
	#print(current_index)
	if Input.is_action_just_pressed("esc") and GLOBAL.is_inside_level:
		if self.visible:
			unpause()
		else:
			pause()
			current_index = 0
			update_focus()
	if $Menu.visible:
		if Input.is_action_just_pressed("jump"):
			$Menu.get_child(current_index).select()
		if Input.is_action_just_pressed("move_down"):
			if current_index < $Menu.get_child_count() - 1:
				current_index += 1
				update_cells()
		if Input.is_action_just_pressed("move_up"):
			if current_index > 0:
				current_index -= 1
				update_cells()
		if Input.is_action_just_pressed("back"):
			unpause()
	if get_viewport().get_camera_2d() != null:
		self.global_position = get_viewport().get_camera_2d().global_position - self.size/2
	else:
		self.global_position = Vector2()

func update_focus():
	for i in range($Menu.get_child_count()):
		if i == current_index:
			$Menu.get_child(i).focus()
		else:
			$Menu.get_child(i).unfocus()

func update_cells():
	for i in range($Menu.get_child_count()):
		if i == current_index:
			$Menu.get_child(i).hover()
		else:
			$Menu.get_child(i).unhover()

func _on_resume_selected() -> void:
	unpause()

func _on_level_selection_selected() -> void:
	unpause()
	get_tree().change_scene_to_file(GLOBAL.current_level_selection)

func _on_options_selected() -> void:
	$Menu.hide()
	$Options.show()

func _on_quit_selected() -> void:
	unpause()
	get_tree().change_scene_to_file("res://Scenes/UI/Menus/MainMenu/main_menu.tscn")

func _on_options_closed() -> void:
	$Menu.show()
