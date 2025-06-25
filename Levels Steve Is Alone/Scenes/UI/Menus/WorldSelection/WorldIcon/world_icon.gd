extends Control

signal finished_unlocking

@export var locked : bool = false
@export var price : int = 0

@export var title : String
@export var world_color : Color
@export var world_path : String
@export var folder_path : String
@export var song : String

func _ready():
	if locked:
		$Background/Label.hide()
		$Background/Trophy.hide()
		$Background/LockedBackground.show()
	else:
		$Background/Label.show()
		$Background/Trophy.show()
		$Background/LockedBackground.hide()
	$Background/Label.text = title
	if WORLDPROGRESS.current_coins[self.get_index()].size() >= WORLDPROGRESS.coins_indexes[self.get_index()].size():
		$Background/Trophy.modulate = Color(1.0, 1.0, 1.0, 1.0)
	#$Background/CurrentCoins/Label.text = str(WORLDPROGRESS.current_coins[self.get_index()].size()) + "/" + str(WORLDPROGRESS.coins_indexes[self.get_index()].size())
	$Background.self_modulate = world_color

func hover(direction : int):
	$Background/IconHover.show()
	if direction == 0:
		$AnimationPlayer.play("hover_left")
	else:
		$AnimationPlayer.play("hover_right")

func set_unlocked():
	locked = false
	$Background/Label.show()
	$Background/Trophy.show()
	$Background/LockedBackground.hide()

func unlock():
	locked = false
	$AnimationPlayer.play("unlock")

func unhover():
	$Background/IconHover.hide()
	$AnimationPlayer.play("RESET")

func select():
	if locked:
		$AnimationPlayer.play("select_locked")
	else:
		$AnimationPlayer.play("select")

func set_coin_progress(coin_amount):
	$Background/LockedBackground/UnlockCoins/Label.text = str(coin_amount) + "/" + str(price)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "unlock":
		print("aq emiti o finished unlocking")
		finished_unlocking.emit()
		set_unlocked()
