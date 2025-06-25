extends Area2D

var orb_displacement = Vector2()

var current_body = null

func _ready() -> void:
	await get_parent().ready
	var player_node = get_parent().get_node_or_null("Player")
	if player_node != null:
		player_node.dead.connect(_on_body_death)

func _process(_delta: float) -> void:
	if current_body == null:
		$Orb.global_position = lerp($Orb.global_position, self.global_position, 0.1)
	else:
		$Orb.global_position = lerp($Orb.global_position, current_body.global_position + orb_displacement, 0.2)
		if current_body.velocity.x > 0:
			orb_displacement = Vector2(-5, -7)
		elif current_body.velocity.x < 0:
			orb_displacement = Vector2(5, -7)

		if current_body.dash_recharged:
			$Orb.frame = 1
		else:
			$Orb.frame = 0

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") :
		current_body = body
		current_body.enable_dash()

func _on_body_death():
	if current_body != null:
		current_body.disable_dash()
		current_body = null
		$Orb.frame = 0
