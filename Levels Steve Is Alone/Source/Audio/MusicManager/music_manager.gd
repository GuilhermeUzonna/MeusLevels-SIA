extends AudioStreamPlayer

var prologue = preload("res://Assets/Sounds/Songs/prologue.mp3")
var challenges1 = preload("res://Assets/Sounds/Songs/challenges_1.mp3")
var challenges2 = preload("res://Assets/Sounds/Songs/challenges_2.mp3")

var songs = {
	"prologue":[prologue],
	"challenges":[challenges1, challenges2]
}

var current_key = ""

var song_queue = []
var queue_position = 0

#func _process(_delta: float) -> void:
	#print(song_queue)
	#print(queue_position)

func update_volume() -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(CONFIG.music_volume))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sounds"), linear_to_db(CONFIG.sounds_volume))

func transition_to(key : String):
	if key == "stop":
		current_key = key
		self.stop()
		return

	queue_position = 0

	if key != current_key:
		song_queue = []
		current_key = key
		for element in songs[key]:
			song_queue.append(element)
	else:
		return

	self.volume_db = -80
	var tween = create_tween()
	tween.tween_property(self, "volume_db", CONFIG.music_volume, 0.0)
	play_queue()
	await tween.finished
	tween.kill()

func play_queue():
	#self.stream = load(song_queue[queue_position])
	self.stream = song_queue[queue_position]
	self.play()

func _on_finished() -> void:
	if song_queue.size() > 1:
		if queue_position < (song_queue.size() - 1):
			queue_position += 1
		else:
			queue_position = 0
	#self.stream = load(song_queue[queue_position])
	self.stream = song_queue[queue_position]
	self.play()
