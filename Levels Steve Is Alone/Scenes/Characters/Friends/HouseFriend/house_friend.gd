extends Area2D

@export var index : int

func _ready() -> void:
	GLOBAL.friend_visit = false
	if index in WORLDPROGRESS.current_friends:
		self.show()
	else:
		self.hide()
		$StaticBody2D/CollisionShape2D.set_deferred("disabled", true)

func _on_body_entered(body):
	if body.is_in_group("player"):
		if !$AnimationPlayer.is_playing():
			$AnimationPlayer.play("jump")
