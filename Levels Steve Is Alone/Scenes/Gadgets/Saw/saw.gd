@tool

extends Node2D

@export var moving : bool = false:
	set(new_moving):
		moving = new_moving

@export var displacement : Vector2:
	set(new_displacement):
		displacement = new_displacement
		update_tooltip()

@export var initial_position : Vector2:
	set(new_initial_position):
		initial_position = new_initial_position
		update_initial_position()

@export var duration : float = 1.0

var begin_keyframe
var end_keyframe

var tween

func _ready():
	if moving and !Engine.is_editor_hint():
		$Line2D.points = [Vector2(0,0), displacement]
		$cap1.position = Vector2(0,0)
		$cap2.position = Vector2(0,0) + displacement
		$Line2D.show()
		$Tooltip.hide()
		set_process(false)
		begin_keyframe = Vector2(0,0)
		end_keyframe = Vector2(0,0) + displacement

		initial_movement()

func initial_movement():
	if initial_position != Vector2():
		var displacement_ratio = begin_keyframe.distance_to(end_keyframe) / duration
		var initial_speed = $Blade.position.distance_to(end_keyframe) / displacement_ratio
		#print(initial_speed)
		if initial_position != end_keyframe:
			tween = create_tween()
			tween.tween_property($Blade, "position", end_keyframe, initial_speed)
			await tween.finished
			tween.kill()

		tween = create_tween()
		tween.set_loops()
		tween.tween_property($Blade, "position", begin_keyframe, duration)
		tween.tween_property($Blade, "position", end_keyframe, duration)
	else:
		tween = create_tween()
		tween.set_loops()
		tween.tween_property($Blade, "position", end_keyframe, duration)
		tween.tween_property($Blade, "position", begin_keyframe, duration)

func _process(_delta):
	if moving:
		$Tooltip.show()
		$Line2D.show()
	else:
		$Tooltip.hide()
		$Line2D.hide()

func update_tooltip():
	$Tooltip.global_position = $Blade.global_position + displacement
	$Line2D.points = [Vector2(0,0), displacement]

func update_initial_position():
	$Blade.position = initial_position
