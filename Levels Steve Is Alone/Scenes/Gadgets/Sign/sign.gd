extends Control

@export var has_image: bool = false
@export var input_sheet : Texture2D

@export_multiline var description : String

func _ready() -> void:
	$Pivot/HBoxContainer/Label.text = description
	$Pivot/HBoxContainer/TextureRect.texture.atlas = input_sheet
	await get_tree().create_timer(0.1).timeout
	$Pivot/HBoxContainer.position.x = (-$Pivot/HBoxContainer.size.x/2) + 4
	$Pivot/HBoxContainer.position.y = -9

func _physics_process(_delta: float) -> void:
	if has_image:
		match GLOBAL.current_input_type:
			"keyboard":
				$Pivot/HBoxContainer/TextureRect.texture.region = Rect2(0, 0, 18, 8)
			"joystick":
				if CONFIG.button_display == "xbox":
					$Pivot/HBoxContainer/TextureRect.texture.region = Rect2(18, 0, 18, 8)
				elif CONFIG.button_display == "playstation":
					$Pivot/HBoxContainer/TextureRect.texture.region = Rect2(36, 0, 18, 8)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		$AnimationPlayer.play("fade_in")

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		$AnimationPlayer.play("fade_out")
