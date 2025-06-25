extends Control

signal selected

@export var title : String

func _ready():
	$Label2.text = title

func focus():
	$AnimationPlayer.play("hover")

func unfocus():
	$AnimationPlayer.play("unhover")

func hover():
	focus()
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(0, self.position.y + 2), 0.05)
	await tween.finished
	tween.kill()
	
	tween = create_tween()
	tween.tween_property(self, "position", Vector2(0, self.position.y - 3), 0.05)
	await tween.finished
	tween.kill()

	tween = create_tween()
	tween.tween_property(self, "position", Vector2(0, self.position.y + 1), 0.05)
	await tween.finished
	tween.kill()

func unhover():
	$AnimationPlayer.play("unhover")

func select():
	selected.emit()
