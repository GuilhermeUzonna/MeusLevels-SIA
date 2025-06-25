@tool

extends CollisionShape2D

signal stepping
signal not_stepping

func set_texture(id : String):
	if id == "center":
		$center.show()
		$left.hide()
		$right.hide()
	elif id == "left":
		$center.hide()
		$left.show()
		$right.hide()
	elif id == "right":
		$center.hide()
		$left.hide()
		$right.show()

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		stepping.emit(body)
		#emit_signal("stepping", body)

func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		not_stepping.emit()
		#emit_signal("not_stepping")
