@tool

extends CollisionShape2D

func _on_player_detector_body_entered(body):
	if body.is_in_group("player") and !$AnimationPlayer.is_playing():
		$AnimationPlayer.play("break")
