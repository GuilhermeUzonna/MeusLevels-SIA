extends Control

var timer = 0.0

var is_timer_visible : bool = false

func _ready() -> void:
	set_process(false)

func _physics_process(_delta: float) -> void:
	if get_viewport().get_camera_2d() != null:
		self.global_position = get_viewport().get_camera_2d().global_position - self.size/2
	else:
		self.global_position = Vector2()
	if is_timer_visible:
		self.show()
	else:
		self.hide()

func _process(delta: float) -> void:
	timer += delta
	var minutos = int(timer / 60)
	var segundos = int(timer) % 60
	var milesimos = (timer - int(timer)) * 100
	if minutos < 10:
		minutos = "0"+str(minutos)
	if segundos < 10:
		segundos = "0"+str(segundos)
	if milesimos < 10:
		milesimos = "0"+str(milesimos)
	$Label.text = str(minutos) + ":" + str(segundos) + "." + str(milesimos).pad_decimals(0)

func start() -> void:
	set_process(true)

func stop() -> void:
	set_process(false)

func reset():
	timer = 0.0
	$Label.text = "00:00.00"
