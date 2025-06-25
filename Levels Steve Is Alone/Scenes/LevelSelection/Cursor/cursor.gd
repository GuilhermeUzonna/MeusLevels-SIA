extends CharacterBody2D

const SPEED = 50

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D

var stunned = false

func stun():
	stunned = true

func _physics_process(_delta):
	if !stunned:
		if Input.is_action_pressed("move_left"):
			velocity = Vector2(-SPEED,0)
			sprite.play("walk")
			sprite.flip_h = true
		elif Input.is_action_pressed("move_right"):
			velocity = Vector2(SPEED,0)
			sprite.play("walk")
			sprite.flip_h = false
		elif Input.is_action_pressed("move_up"):
			velocity = Vector2(0, -SPEED)
			sprite.play("walk")
		elif Input.is_action_pressed("move_down"):
			velocity = Vector2(0, SPEED)
			sprite.play("walk")
		else:
			velocity = Vector2()
			sprite.play("idle")

		move_and_slide()
