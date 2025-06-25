extends Area2D

func _ready() -> void:
	MusicManager.transition_to("stop")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and !$AnimationPlayer.is_playing():
		MusicManager.transition_to(GLOBAL.current_menu_song)
		$AnimationPlayer.play("jump")
		GLOBAL.friend_collected = true
