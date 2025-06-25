extends Control

@export var title : String

var value

var initial_position
var initial_left_pos
var initial_right_pos

func _ready() -> void:
	$Title.text = title
	initial_position = self.position

func focus():
	$OptionsMenuCell/Label.modulate = Color(1.0, 1.0, 1.0, 1.0)
	$OptionsMenuCell/Label3.modulate = Color(1.0, 1.0, 1.0, 1.0)

func unfocus():
	$OptionsMenuCell/Label.modulate = Color(1.0, 1.0, 1.0, 0.0)
	$OptionsMenuCell/Label3.modulate = Color(1.0, 1.0, 1.0, 0.0)

func hover():
	focus()
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(0, initial_position.y + 2), 0.05)
	await tween.finished
	tween.kill()
	
	tween = create_tween()
	tween.tween_property(self, "position", Vector2(0, initial_position.y - 1), 0.05)
	await tween.finished
	tween.kill()

	tween = create_tween()
	tween.tween_property(self, "position", Vector2(0, initial_position.y), 0.05)
	await tween.finished
	tween.kill()

func unhover():
	unfocus()

func set_value(new_value):
	value = new_value
	$OptionsMenuCell/Label2.text = str(value).pad_decimals(0)

func add_value(amount):
	if value < 10:
		value += amount
	$OptionsMenuCell/Label2.text = str(value).pad_decimals(0)

	initial_right_pos = $OptionsMenuCell/Label3.position.x
	var tween = create_tween()
	tween.tween_property($OptionsMenuCell/Label3, "position", Vector2(initial_right_pos + 2, $OptionsMenuCell/Label3.position.y), 0.05)
	await tween.finished
	tween.kill()

	tween = create_tween()
	tween.tween_property($OptionsMenuCell/Label3, "position", Vector2(initial_right_pos - 1, $OptionsMenuCell/Label3.position.y), 0.05)
	await tween.finished
	tween.kill()

	tween = create_tween()
	tween.tween_property($OptionsMenuCell/Label3, "position", Vector2(initial_right_pos, $OptionsMenuCell/Label3.position.y), 0.05)
	await tween.finished
	tween.kill()

func remove_value(amount):
	if value > 0:
		value -= amount
	$OptionsMenuCell/Label2.text = str(value).pad_decimals(0)

	var tween = create_tween()
	tween.tween_property($OptionsMenuCell/Label, "position", Vector2(initial_left_pos + 2, $OptionsMenuCell/Label.position.y), 0.05)
	await tween.finished
	tween.kill()

	tween = create_tween()
	tween.tween_property($OptionsMenuCell/Label, "position", Vector2(initial_left_pos - 1, $OptionsMenuCell/Label.position.y), 0.05)
	await tween.finished
	tween.kill()

	tween = create_tween()
	tween.tween_property($OptionsMenuCell/Label, "position", Vector2(initial_left_pos, $OptionsMenuCell/Label.position.y), 0.05)
	await tween.finished
	tween.kill()

func get_value():
	return value

func select():
	pass

#func _process(delta: float) -> void:
	#print(self.position)
