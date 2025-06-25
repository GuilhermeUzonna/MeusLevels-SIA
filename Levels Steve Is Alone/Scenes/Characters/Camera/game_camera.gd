extends Camera2D

signal end_of_transition

@onready var world_size : ColorRect = get_parent().get_node("BackgroundColor")
@onready var player : CharacterBody2D = get_parent().get_node("Player")

func transition_out():
	$AnimationPlayer.play("transition_out")

func transition_in():
	$AnimationPlayer.play("transition_in")

func _physics_process(_delta):
	PauseMenu.global_position = self.global_position - PauseMenu.size/2
	SPEEDRUNTIMER.global_position = self.global_position - SPEEDRUNTIMER.size/2
	self.global_position.x = lerp(self.global_position.x, player.global_position.x, 1.0)
	if self.global_position.x < 160:
		self.global_position.x = 160
	elif self.global_position.x > world_size.size.x - 160:
		self.global_position.x = world_size.size.x - 160
	if abs(abs(player.global_position.y) - abs(self.global_position.y)) > 10:
		self.global_position.y = lerp(self.global_position.y, player.global_position.y, 0.05)
	if self.global_position.y < 120:
		self.global_position.y = 120
	elif self.global_position.y > world_size.size.y - 120:
		self.global_position.y = world_size.size.y - 120

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "transition_out":
		end_of_transition.emit()
