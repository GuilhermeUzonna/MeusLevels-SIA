extends Control

var has_continue_button = false

func _ready() -> void:
	var config = ConfigFile.new()
	var _err = config.load("user://save.cfg")

	$Background.color = GLOBAL.current_menu_color
	MusicManager.transition_to(GLOBAL.current_menu_song)
	GLOBAL.is_inside_level = false
	SPEEDRUNTIMER.stop()

func _physics_process(_delta):
	if Input.is_action_just_pressed("jump"):
		$transition_anims.play("transition_out")
		SPEEDRUNTIMER.reset()
		SPEEDRUNTIMER.start()

	#if Input.is_action_just_pressed("key_r"):
		#GLOBAL.current_level_index = 0
		#GLOBAL.position_in_level_selection = Vector2()
		#GLOBAL.level_completed = false
		#GLOBAL.coin_collected = false
		#GLOBAL.friend_collected = false
		#GLOBAL.friend_visit = false
		#WORLDPROGRESS.current_levels = []
		#WORLDPROGRESS.current_coins = []
		#WORLDPROGRESS.current_friends = []
		#get_tree().reload_current_scene()

func _on_transition_anims_animation_finished(anim_name):
	if anim_name == "transition_out":
		get_tree().change_scene_to_file("res://Scenes/UI/Menus/WorldSelection/world_selection.tscn")
