extends Area2D

@export_multiline var title : String
@export var level : String

var active = false

#var index = 0
#
#func set_index(value : int):
	#index = value

func collected():
	$AnimatedSprite2D.play("collected")

func has_coin():
	$AnimatedSprite2D.play("notcollected")

func set_completion(value : int):
	if value == 0:
		$completed.show()
		$Title/LevelTitle.text = title
		active = true
	if value == 1:
		$Sprite2D.modulate = Color(1.0, 1.0, 1.0, 1.0)
		$Title/LevelTitle.text = title
		active = true
	elif value == 2:
		$Sprite2D.modulate = Color(1.0, 1.0, 1.0, 0.5)
		$Title/LevelTitle.text = "???"
		active = false

func _ready():
	set_process(false)
	$Title.global_position = Vector2(160, 64)

func _on_body_entered(body):
	if body.is_in_group("cursor"):
		$AnimationPlayer.play("fade_in")
		set_process(true)

func _on_body_exited(body):
	if body.is_in_group("cursor"):
		$AnimationPlayer.play("fade_out")
		set_process(false)

func _process(_delta):
	if Input.is_action_just_pressed("jump") and active:
		get_parent().select_level(self)

func play_intro():
	$intro_anim.play("slide_in")
