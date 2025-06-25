@tool

extends Node2D

var being_pushed = false
var pushing_body = null

var cell_scene = load("res://Scenes/Gadgets/TiltingPlatform/TiltingPlatformCell/tilting_platform_cell.tscn")

var queue_push_stop = false 

var areas_entered = 0
var areas_exited = 0

@export var left_size : int = 0:
	set(new_size):
		left_size = new_size
		#update()

@export var right_size : int = 0:
	set(new_size):
		right_size = new_size
		#update()

@export_range(-30, 30) var initial_rotation : float = 0.0:
	set(new_rotation):
		initial_rotation = new_rotation
		update_rotation()

func _ready():
	update()
	await get_parent().ready
	var player_node = get_parent().get_node_or_null("Player")
	if player_node != null:
		player_node.dead.connect(_on_body_death)

func _on_body_death():
	update_rotation()

func _is_being_pushed(body):
	areas_entered += 1
	pushing_body = body

func _not_being_pushed():
	areas_entered -= 1

func _physics_process(_delta):
	if not Engine.is_editor_hint():
		if areas_entered > areas_exited:
			$RigidBody2D.apply_force(Vector2(0, 5), Vector2((pushing_body.global_position.x - $RigidBody2D.global_position.x), 0))
		if $RigidBody2D.rotation_degrees < -30:
			$RigidBody2D.rotation_degrees = -30
			$RigidBody2D.angular_velocity = 0
		if $RigidBody2D.rotation_degrees > 30:
			$RigidBody2D.rotation_degrees = 30
			$RigidBody2D.angular_velocity = 0
	else:
		update()

func update():
	await clear_children()
	if Engine.is_editor_hint():
		await get_tree().create_timer(0.1).timeout
	await update_children()
	await update_textures()

func clear_children():
	for child in $RigidBody2D.get_children():
		if not child.is_in_group("keep"):
			child.queue_free()

func update_children():
	var left_pos = 0
	left_pos = - (left_size * 8)
	for i in range(left_size):
		var cell_instance = cell_scene.instantiate()
		$RigidBody2D.add_child(cell_instance)
		if Engine.is_editor_hint():
			cell_instance.owner = get_tree().edited_scene_root
		cell_instance.position.x = left_pos
		left_pos += 8
		cell_instance.stepping.connect(_is_being_pushed)
		cell_instance.not_stepping.connect(_not_being_pushed)

	var right_pos = 0
	right_pos = 8
	for i in range(right_size):
		var cell_instance = cell_scene.instantiate()
		$RigidBody2D.add_child(cell_instance)
		if Engine.is_editor_hint():
			cell_instance.owner = get_tree().edited_scene_root
		cell_instance.position.x = right_pos
		right_pos += 8
		cell_instance.stepping.connect(_is_being_pushed)
		cell_instance.not_stepping.connect(_not_being_pushed)

func update_textures():
	for child in $RigidBody2D.get_children():
		child.set_texture("center")
	if left_size == 0:
		$RigidBody2D.get_child(0).set_texture("left")
	else:
		$RigidBody2D.get_child(1).set_texture("left")
	if right_size == 0:
		$RigidBody2D.get_child(0).set_texture("right")
	else:
		$RigidBody2D.get_child($RigidBody2D.get_child_count() - 1).set_texture("right")

func update_rotation():
	$RigidBody2D.rotation_degrees = initial_rotation
