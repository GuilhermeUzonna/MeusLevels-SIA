@tool

extends Control

@export var data_alvo : String = "2025-12-31"

var weeks = 0
var days = 0
var hours = 0
var minutes = 0
var seconds = 0

func _ready() -> void:
	if OS.get_locale() != "pt_BR":
		$Label.text = "click to replay intro"
		$HBoxContainer/Weeks/title.text = "weeks"
		$HBoxContainer/Days/title.text = "days"
		$HBoxContainer/Hours/title.text = "hours"
		$HBoxContainer/Minutes/title.text = "minutes"
		$HBoxContainer/Seconds/title.text = "seconds"

func update_time():
	#print(OS.get_locale())
	var unix_time_left = Time.get_unix_time_from_datetime_string(data_alvo) - (Time.get_unix_time_from_system() + Time.get_time_zone_from_system().bias * 60) + 64800

	if unix_time_left > 604800:
		weeks = unix_time_left / 604800
		unix_time_left -= 604800 * int(weeks)
	if unix_time_left > 86400:
		days = unix_time_left / 86400
		unix_time_left -= 86400 * int(days)
	if unix_time_left > 3600:
		hours = unix_time_left / 3600
		unix_time_left -= 3600 * int(hours)
	if unix_time_left > 60:
		minutes = unix_time_left / 60
		unix_time_left -= 60 * int(minutes)
	seconds = unix_time_left + 1

func _process(delta: float) -> void:
	update_time()
	$HBoxContainer/Weeks.text = str(weeks).pad_decimals(0).pad_zeros(2)
	$HBoxContainer/Days.text = str(days).pad_decimals(0).pad_zeros(2)
	$HBoxContainer/Hours.text = str(hours).pad_decimals(0).pad_zeros(2)
	$HBoxContainer/Minutes.text = str(minutes).pad_decimals(0).pad_zeros(2)
	$HBoxContainer/Seconds.text = str(seconds).pad_decimals(0).pad_zeros(2)

func _on_label_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			get_tree().reload_current_scene()
	if event is InputEventScreenTouch:
		if event.pressed:
			get_tree().reload_current_scene()
