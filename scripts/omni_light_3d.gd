extends OmniLight3D

@export var flicker_speed: float = 10.0
@export var flicker_intensity: float = 0.4
@export var base_energy: float = 3.0

var time: float = 0.0

func _process(delta):
	time += delta
	# noise sinusoidal berlapis = efek api natural
	var flicker = sin(time * flicker_speed) * 0.5
	flicker += sin(time * flicker_speed * 2.3) * 0.3
	flicker += sin(time * flicker_speed * 0.7) * 0.2
	light_energy = base_energy + flicker * flicker_intensity
