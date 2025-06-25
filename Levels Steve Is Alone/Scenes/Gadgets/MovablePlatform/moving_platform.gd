@tool

extends Node2D

var cell_scene = load("res://Scenes/Gadgets/MovablePlatform/MovingPlatformCell/moving_platform_cell.tscn")

@export var displacement : Vector2:
	set(new_displacement):
		displacement = new_displacement
		update_tooltip()

@export var initial_position : Vector2:
	set(new_initial_position):
		initial_position = new_initial_position
		update_initial_position()

@export var duration : float = 1.0

@export var size : int = 0:
	set(new_size):
		size = new_size
		update()

var begin_keyframe
var end_keyframe

var tween

func _ready():
	if Engine.is_editor_hint():
		update()
	if not Engine.is_editor_hint():
		$Tooltip.hide()
		begin_keyframe = Vector2(0,0)
		end_keyframe = Vector2(0,0) + displacement

		initial_movement()

		await update_textures()
		await update_position()

func initial_movement():
	if initial_position != Vector2():
		tween = create_tween()
		var displacement_ratio = begin_keyframe.distance_to(end_keyframe) / duration
		var initial_speed = $AnimatableBody.position.distance_to(end_keyframe) / displacement_ratio
		#print(initial_speed)
		if initial_position != end_keyframe:
			tween.tween_property($AnimatableBody, "position", end_keyframe, initial_speed)
			await tween.finished
			tween.kill()

		tween = create_tween()
		tween.set_loops()
		tween.tween_property($AnimatableBody, "position", begin_keyframe, duration)
		tween.tween_property($AnimatableBody, "position", end_keyframe, duration)
	else:
		tween = create_tween()
		tween.set_loops()
		tween.tween_property($AnimatableBody, "position", end_keyframe, duration)
		tween.tween_property($AnimatableBody, "position", begin_keyframe, duration)

func update():
	await clear_children()
	if Engine.is_editor_hint():
		await get_tree().create_timer(0.1).timeout #buffer pra dar tempo de atualizar os nodes
	await update_children()
	await update_textures()
	await update_position()
	await update_initial_position()
	await update_tooltip()

func clear_children():
	for child in $AnimatableBody.get_children():
		child.queue_free()

func update_children():
	for i in range(size):
		var cell_instance = cell_scene.instantiate()
		$AnimatableBody.add_child(cell_instance)
		if Engine.is_editor_hint():
			cell_instance.owner = get_tree().edited_scene_root

func update_textures():
	if $AnimatableBody.get_child_count() == 1:
		$AnimatableBody.get_child(0).set_id("solo")
	elif $AnimatableBody.get_child_count() > 1:
		for i in range($AnimatableBody.get_child_count()):
			if i == 0:
				$AnimatableBody.get_child(i).set_id("left")
			elif i == $AnimatableBody.get_child_count() - 1:
				$AnimatableBody.get_child(i).set_id("right")
			else:
				$AnimatableBody.get_child(i).set_id("center")

func update_position():
	var pos = 0
	pos = - ($AnimatableBody.get_child_count() - 1) * 4
	for child in $AnimatableBody.get_children():
		child.position.x = pos
		pos += 8

func update_initial_position():
	$AnimatableBody.position = initial_position

func update_tooltip():
	$Tooltip.size.x = $AnimatableBody.get_child_count() * 8
	$Tooltip.position = Vector2(0,0) + displacement - $Tooltip.get_rect().size/2
