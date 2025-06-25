extends GPUParticles2D

func _ready():
	randomize()
	$pickup_sound.pitch_scale = randf_range(1.4, 1.8)
	self.emitting = true

func _on_finished():
	queue_free()
