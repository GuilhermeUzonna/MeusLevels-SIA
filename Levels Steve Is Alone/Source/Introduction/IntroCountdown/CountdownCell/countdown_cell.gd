extends Label

@export var title : String = "title"

func _ready() -> void:
	$title.text = title
