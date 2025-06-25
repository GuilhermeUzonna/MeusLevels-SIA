extends Area2D

const COOLDOWN_TIME = 3.0

var active = true

func _on_body_entered(body):
	if active:
		if body.is_in_group("player"):
			body.buffer_double_jump()
			$AnimatedSprite2D.play("pickup")
			active = false
			$cooldown.start(COOLDOWN_TIME)

func _on_cooldown_timeout():
	$AnimatedSprite2D.play("respawn")
	active = true

func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "respawn":
		$AnimatedSprite2D.play("idle")
