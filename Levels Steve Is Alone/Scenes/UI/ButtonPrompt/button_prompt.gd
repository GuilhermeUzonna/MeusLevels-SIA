extends HBoxContainer

@export var input_sheet : Texture
@export var description : String

func _ready() -> void:
	$Label.text = description
	$TextureRect.texture.atlas = input_sheet

func _physics_process(_delta: float) -> void:
	match GLOBAL.current_input_type:
		"keyboard":
			$TextureRect.texture.region = Rect2(0, 0, 18, 8)
		"joystick":
			if CONFIG.button_display == "xbox":
				$TextureRect.texture.region = Rect2(18, 0, 18, 8)
			elif CONFIG.button_display == "playstation":
				$TextureRect.texture.region = Rect2(36, 0, 18, 8)
