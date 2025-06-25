@tool

extends StaticBody2D

var world_size : ColorRect

var key_starting_pos = Vector2(0, 0)
var current_target = null
var offset = Vector2()
var locked = true
var key_returning = false #impede que a chave siga o player ou destranque a lock enquanto retorna

func _ready() -> void:
	if !Engine.is_editor_hint():
		world_size = get_parent().get_node("BackgroundColor")
		key_starting_pos = $Marker2D.global_position
		$Key.global_position = key_starting_pos
		$KeyDetector.set_deferred("monitoring", true)

func _process(_delta: float) -> void:
	if Engine.is_editor_hint() and get_node_or_null("Marker2D") != null:
		$Key.global_position = lerp($Key.global_position, $Marker2D.global_position, 0.3)
	else:
		if current_target == null:
			$Key.global_position = lerp($Key.global_position, key_starting_pos, 0.3)
			if $Key.global_position.distance_to(key_starting_pos) < 1:
				key_returning = false
		else:
			$Key.global_position = lerp($Key.global_position, current_target.global_position + offset, 0.5)
			if current_target is CharacterBody2D:
				if current_target.velocity.y >= 150:
					offset = Vector2(0, 15)
				else:
					if current_target.get_node("AnimatedSprite2D").flip_h:
						$Key/Sprite2D.flip_h = false
						offset = Vector2(-9, 0)
					else:
						$Key/Sprite2D.flip_h = true
						offset = Vector2(9, 0)

	if get_node_or_null("Marker2D") != null:
		$Line2D.points[1] = Vector2(0, $Key.position.y)
		$Line2D.points[2] = $Key.position

	if !Engine.is_editor_hint():
		if $Padlock.global_position.y > world_size.size.y + 10:
			$Padlock.freeze = true

func _on_key_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and !key_returning and locked:
		current_target = body
		if !current_target.dead.is_connected(_on_body_death):
			current_target.dead.connect(_on_body_death)

func _on_body_death():
	if locked:
		current_target = null
		key_returning = true
	else:
		locked = false
		current_target = null
		reset()

func _on_key_detector_area_entered(area: Area2D) -> void:
	if area == $Key and !key_returning:
		locked = false
		offset = Vector2()
		current_target = $Padlock
		disable()

func disable():
	$Padlock.set_deferred("freeze", false)
	$Padlock.linear_velocity = Vector2(0, -200)
	$Background.play("break")
	$CollisionShape2D.set_deferred("disabled", true)
	$Key/CollisionShape2D.set_deferred("disabled", true)
	$Line2D.hide()

func reset():
	locked = true
	offset = Vector2(9, 0)
	$Key/CollisionShape2D.set_deferred("disabled", false)
	$Padlock.set_deferred("freeze", true)
	$Background.play_backwards("break")
	$CollisionShape2D.set_deferred("disabled", false)
	$Padlock.global_position = self.global_position
	$Key.global_position = key_starting_pos
	$Line2D.show()
	$Padlock/AnimationPlayer.play("spawn")
	$Key/AnimationPlayer.play("spawn")

func _get_configuration_warnings():
	var warnings = []

	if get_node_or_null("Marker2D") == null:
		warnings.append("Adicione um node Marker2D como filho deste node para determinar a posição da chave.")

	return warnings
