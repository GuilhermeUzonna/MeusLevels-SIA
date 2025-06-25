@tool

extends CollisionShape2D

var cell_id = ""

func _ready():
	update_texture()

func set_id(value : String):
	cell_id = value
	update_texture()

func _process(_delta):
	update_texture()

func update_texture():
	if cell_id == "center":
		hide_children(0)
	elif cell_id == "left":
		hide_children(1)
	elif cell_id == "right":
		hide_children(2)
	elif cell_id == "solo":
		hide_children(3)

func hide_children(index : int):
	for i in range(self.get_child_count()):
		if i == index:
			get_child(i).show()
		else:
			get_child(i).hide()
