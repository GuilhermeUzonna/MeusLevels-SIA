extends Control

func _on_left_gui_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			Input.action_press("move_left")
		else:
			Input.action_release("move_left")

func _on_right_gui_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			Input.action_press("move_right")
		else:
			Input.action_release("move_right")

func _on_jump_gui_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			Input.action_press("jump")
		else:
			Input.action_release("jump")
