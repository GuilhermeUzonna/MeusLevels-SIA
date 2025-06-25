extends CharacterBody2D

class_name Player

signal dead

var TERMINAL_FALLING_VELOCITY = 150.0
var TERMINAL_FLYING_VELOCITY = -150.0
const DASH_FACTOR = 2.5
const DASH_MAX_FRAMES = 10
const DASH_DELAY = 1.0

var GRAVITY = 400
var TOP_SPEED = 60.0
var ACCEL = 60.0
var DEACCEL = 50.0
var JUMP_FORCE = -140.0
var FORCE_DEACCEL = 50.0
var AIR_RESISTANCE = 10.0

var applied_forces = Vector2()
var is_being_pushed = false
var push_number = 0

var JUMP_BUFFER_AMOUNT = 5
var jump_buffer = 0
var jumped_from_buffer = false

var double_jump = false
var double_jump_buffer = false

var is_able_to_dash = false
var dash_frames = 10
var dash_recharged = false
var is_dashing = false
var DASH_BUFFER_AMOUNT = 5
var dash_buffer = 0

var grab_buffer = false
var wall_jump = false
var can_grab = true
var is_grabbing = false

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var current_checkpoint : Marker2D = get_parent().get_node("SpawnPoint")

@onready var world_size : ColorRect = get_parent().get_node("BackgroundColor")

var death_particles_scene = load("res://Scenes/Characters/Player/DeathParticles/death_particles.tscn")

var dash_particles_scene = load("res://Scenes/Characters/Player/DashParticles/dash_particle.tscn")

var is_falling = false

#region Funções de Alteração Comportamental
func invert_gravity():
	GRAVITY *= -1

func apply_force(direction : Vector2, intensity : float):
	applied_forces = direction * intensity

func buffer_double_jump():
	double_jump = true

func stop_gravity_for(time_in_seconds : float):
	GRAVITY = 0
	$stop_gravity.start(time_in_seconds)

func apply_gravity():
	$stop_gravity.stop()
	GRAVITY = 400

func push(value : int):
	push_number += value
	if push_number > 0:
		is_being_pushed = true
	else:
		is_being_pushed = false

func stick_to_wall(duration : float):
	print("chamou stick")
	$grab_wall.start(duration)
	is_grabbing = true
	wall_jump = true

func drop_from_wall():
	print("chamou drop")
	$grab_wall.stop()
	is_grabbing = false
	$wall_jump_buffer.start(0.075)
	#wall_jump = false
	can_grab = false
	$grab_delay.start(0.2)

func enable_dash():
	is_able_to_dash = true
	dash_recharged = true

func disable_dash():
	is_able_to_dash = false
	dash_recharged = false

func open_glider():
	GRAVITY = 100
	JUMP_FORCE = -70
	TERMINAL_FALLING_VELOCITY = 50.0

func close_glider():
	GRAVITY = 400
	JUMP_FORCE = -140
	TERMINAL_FALLING_VELOCITY = 150.0
#endregion

func _ready():
	self.global_position = current_checkpoint.global_position

func _physics_process(delta):
	$debug.text = "grab_buffer: " + str(grab_buffer) + "\ncan_grab: " + str(can_grab) + " \nwall_jump" + str(wall_jump)

	#if Input.is_action_just_pressed("key_r"):
		#die()

	if self.global_position.y > world_size.size.y:
		die()

	#Implementa o dash
	if is_dashing:
		velocity.y = 0
		velocity.x = sign(velocity.x) * DASH_FACTOR * TOP_SPEED
		dash_frames -= 1
		if dash_frames <= 0:
			dash_frames = DASH_MAX_FRAMES
			is_dashing = false
		var dash_particle = dash_particles_scene.instantiate()
		get_parent().add_child(dash_particle)
		dash_particle.global_position = self.global_position
		dash_particle.flip_h = sprite.flip_h
	else:
	# Adiciona a gravidade.
		if not is_on_floor():
			sprite.play("jump")
			velocity.y += GRAVITY * delta

			if velocity.y > TERMINAL_FALLING_VELOCITY:
				velocity.y = TERMINAL_FALLING_VELOCITY
			if velocity.y < TERMINAL_FLYING_VELOCITY:
				velocity.y = TERMINAL_FLYING_VELOCITY

			if Input.is_action_just_pressed("jump"):
				jump_buffer = JUMP_BUFFER_AMOUNT

			if Input.is_action_just_pressed("dash"):
				dash_buffer = DASH_BUFFER_AMOUNT
		else:
			velocity.y = 0
			if is_able_to_dash:
				dash_recharged = true

		if is_on_floor() and $deform_animations.assigned_animation == "jump":
				$deform_animations.play("land")

	# Implementa o pulo.
		if jump_buffer > 0:
			jump_buffer -= 1

		if Input.is_action_just_pressed("jump") or jump_buffer > 0:
			if jump_buffer > 0:
				jumped_from_buffer = true
			if $deform_animations.assigned_animation != "jump":
				$deform_animations.play("jump")
			if is_on_floor() or double_jump or wall_jump:
				randomize()
				$jump_sound.pitch_scale = randf_range(0.8, 1.2)
				$jump_sound.play()
				velocity.y = JUMP_FORCE
				double_jump = false
				wall_jump = false
				is_grabbing = false
		elif Input.is_action_just_released("jump"):
			if velocity.y < 0:
				velocity.y *= 0.5
		elif !Input.is_action_pressed("jump"):
			if jumped_from_buffer:
				if velocity.y < 0:
					velocity.y *= 0.5
				jumped_from_buffer = false
			#if double_jump_buffer: #buffer pra impedir que o pulo duplo seja usado imediatamente caso o botao de pulo esteja pressionado
				#double_jump = true
				#double_jump_buffer = false

		# Implementa o movimento.
		if Input.is_action_pressed("move_right"):
			if is_on_floor():
				sprite.play("walk")
			sprite.flip_h = false
			if velocity.x < TOP_SPEED:
				velocity.x = TOP_SPEED
		elif Input.is_action_pressed("move_left"):
			if is_on_floor():
				sprite.play("walk")
			sprite.flip_h = true
			if velocity.x > -TOP_SPEED:
				velocity.x = -TOP_SPEED
		elif !is_dashing:
			if is_on_floor():
				$AnimatedSprite2D.play("idle")
			if abs(velocity.x) < DEACCEL:
				velocity.x = 0
			else:
				velocity.x += DEACCEL * sign(velocity.x) * -1

		if is_being_pushed:
			velocity += applied_forces
		elif !is_being_pushed and is_on_floor():
			if abs(velocity.x) > TOP_SPEED:
				velocity.x = velocity.x + (FORCE_DEACCEL * sign(velocity.x) * -1)
			applied_forces.x = 0
			applied_forces.y = 0
		elif !is_being_pushed and !is_on_floor():
			if abs(velocity.x) > TOP_SPEED:
				velocity.x = velocity.x + (AIR_RESISTANCE * sign(velocity.x) * -1)

		#Aiva o dash
		if dash_buffer > 0:
			dash_buffer -= 1 

		if Input.is_action_just_pressed("dash") or dash_buffer:
			if velocity.x != 0 and !is_dashing and dash_recharged:
				dash_buffer = 0
				is_dashing = true
				dash_recharged = false
	
		#Comportamento wall jump
		if is_grabbing and !is_on_floor():
			velocity.y *= 0.6
			sprite.play("grab")

	move_and_slide()

func _on_tilemap_detector_body_entered(body):
	if body.is_in_group("hazard"):
		die()
		#else:
			#grab_buffer = true

func die():
	var death_particles = death_particles_scene.instantiate()
	death_particles.global_position = self.global_position
	get_parent().add_child(death_particles)
	velocity = Vector2()
	self.global_position = current_checkpoint.global_position
	#emit_signal("dead")
	dead.emit()

func _on_grab_wall_timeout():
	drop_from_wall()

func _on_grab_delay_timeout():
	can_grab = true
	if grab_buffer:
		grab_buffer = false
		stick_to_wall(1)

func _on_wall_jump_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("wall_jump"):
		if can_grab:
			stick_to_wall(1)
		else:
			grab_buffer = true

func _on_wall_jump_detector_body_exited(body: Node2D) -> void:
	if body.is_in_group("wall_jump"):
		drop_from_wall()
		grab_buffer = false

func _on_smashed_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("solid"):
		die()

func _on_wall_jump_buffer_timeout() -> void:
	wall_jump = false
	pass
