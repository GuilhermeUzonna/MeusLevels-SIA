@tool

extends Node2D

var cell_scene = load("res://Scenes/Gadgets/BreakableTiles/BreakableCell/breakable_cell.tscn")

@export var size : int = 0:
	set(new_size):
		size = new_size
		update()

@export var vertical : bool = false:
	set(new_value):
		vertical = new_value
		update_position()

@export var wall_jump : bool = false:
	set(new_wall_jump):
		wall_jump = new_wall_jump
		set_wall_jump(new_wall_jump)

func set_wall_jump(value):
	if value:
		$StaticBody2D.add_to_group("wall_jump")
	else:
		$StaticBody2D.remove_from_group("wall_jump")

func _ready():
	if Engine.is_editor_hint():
		update()

func update():
	await clear_children()
	if Engine.is_editor_hint():
		await get_tree().create_timer(0.1).timeout
	await update_children()
	await update_position()

func clear_children():
	for child in $StaticBody2D.get_children():
		child.queue_free()

func update_children():
	for i in range(size):
		var cell_instance = cell_scene.instantiate()
		$StaticBody2D.add_child(cell_instance)
		if Engine.is_editor_hint():
			cell_instance.owner = get_tree().edited_scene_root

func update_position():
	var pos = 0
	pos = - ($StaticBody2D.get_child_count() - 1) * 4
	for child in $StaticBody2D.get_children():
		if !vertical:
			child.position.x = pos
			child.position.y = 0
		else:
			child.position.x = 0
			child.position.y = pos
		pos += 8
