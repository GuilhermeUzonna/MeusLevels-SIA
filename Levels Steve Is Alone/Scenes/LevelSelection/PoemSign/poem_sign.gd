extends Area2D

@export var show_poem : bool = false

func set_poem(poem : String):
	$ColorRect/Label.text = poem

func _ready() -> void:
	$ColorRect.global_position = Vector2(0,0)

func show_notification():
	print("aq chamou")
	$Notification.show()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("cursor"):
		$AnimationPlayer.play("fade_in")
		$Notification.hide()

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("cursor"):
		$AnimationPlayer.play("fade_out")
