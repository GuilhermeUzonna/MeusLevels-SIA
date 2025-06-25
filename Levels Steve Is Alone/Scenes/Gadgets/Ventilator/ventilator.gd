@tool

extends Area2D

@export var intensity : int = 10

@export var intermittent : bool = false
@export var time_on : float = 5.0
@export var time_off : float = 5.0

@onready var particles : GPUParticles2D = $GPUParticles2D

var direction

var is_active : bool = true

var current_body_pushed = null

func _ready() -> void:
	if intermittent:
		pulse()

func pulse():
	activate()
	await get_tree().create_timer(time_on).timeout
	deactivate()
	await get_tree().create_timer(time_off).timeout
	pulse()

func activate():
	is_active = true
	$GPUParticles2D.emitting = true
	$AnimatedSprite2D.play()
	$StaticBody2D.add_to_group("hazard")
	self.set_deferred("monitoring", false)
	self.set_deferred("monitoring", true)
	$StaticBody2D/CollisionShape2D.set_deferred("disabled", true)
	$StaticBody2D/CollisionShape2D.set_deferred("disabled", false)

func deactivate():
	is_active = false
	$GPUParticles2D.emitting = false
	$StaticBody2D.remove_from_group("hazard")
	if current_body_pushed != null:
		if current_body_pushed.push_number > 0:
			current_body_pushed.push(-1)

func _process(_delta):
	if !is_active and $AnimatedSprite2D.frame == 0:
		$AnimatedSprite2D.pause()
	direction = $Marker2D.global_position - self.global_position
	var new_gravity : Vector2 = direction * 98
	particles.process_material.set_gravity(Vector3(new_gravity.x, new_gravity.y, 0))

func _on_body_entered(body):
	if body.is_in_group("player") and is_active:
		current_body_pushed = body
		body.push(1)
		body.apply_force(direction, intensity)

func _on_body_exited(body):
	if body.is_in_group("player") and is_active:
		if body.push_number > 0:
			body.push(-1)
