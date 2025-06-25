extends Node2D

@export var level_index : int

var particles = load("res://Scenes/Collectables/Coin/PickupParticles/pickup_particles.tscn")

var current_target = self

func _ready() -> void:
	await get_parent().ready
	var player_node = get_parent().get_node_or_null("Player")
	if player_node != null:
		player_node.dead.connect(_on_body_death)

func picked_up():
	if current_target != self:
		GLOBAL.coin_collected = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		current_target = body
		var particles_instance = particles.instantiate()
		particles_instance.global_position = self.global_position
		get_parent().add_child(particles_instance)
		$Area2D/CollisionShape2D.set_deferred("disabled", true)

func _process(_delta: float) -> void:
	$Area2D.global_position = lerp($Area2D.global_position, current_target.global_position, 0.05)

func _on_body_death():
	current_target = self
	$Area2D/CollisionShape2D.set_deferred("disabled", false)
