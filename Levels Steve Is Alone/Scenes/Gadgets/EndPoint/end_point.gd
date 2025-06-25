extends Area2D

@export var level_index : int = 0

func _on_body_entered(body):
	if body.is_in_group("player"):
		GLOBAL.level_completed = true
		## ESSE IF AQUI DEVE SER REMOVIDO APÓS O EVENTO
		if WORLDPROGRESS.current_levels.size() > 1:
			if WORLDPROGRESS.current_levels[1] >= 9:
				SPEEDRUNTIMER.stop()
		##
		get_parent().end_level()
