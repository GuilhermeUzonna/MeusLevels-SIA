extends Area2D

var orb_displacement = Vector2(0, 0)

var current_body = null

func _process(_delta: float) -> void:
	if current_body == null:
		$Wings.global_position = lerp($Wings.global_position, self.global_position, 0.1)
		if $Wings.global_position.distance_to(self.global_position) > 0.1 and !$Wings.is_playing():
			$Wings.play("flap")
		elif $Wings.global_position.distance_to(self.global_position) < 0.1:
			$Wings.stop()
	else:
		$Wings.global_position = lerp($Wings.global_position, current_body.global_position + orb_displacement, 0.9)

		if current_body.velocity.y < 0 and !$Wings.is_playing():
			$Wings.play("flap")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		current_body = body
		current_body.open_glider()
		$Wings.play("flap")
		if !current_body.dead.is_connected(_on_body_death):
			current_body.dead.connect(_on_body_death)

func _on_body_death():
	current_body.dead.disconnect(_on_body_death)
	current_body.close_glider()
	current_body = null
	$Wings.frame = 0
