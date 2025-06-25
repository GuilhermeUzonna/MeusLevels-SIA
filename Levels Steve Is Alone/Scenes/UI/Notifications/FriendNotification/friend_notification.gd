extends Node2D

func _process(_delta: float) -> void:
	if GLOBAL.friend_visit:
		self.show()
	else:
		self.hide()
