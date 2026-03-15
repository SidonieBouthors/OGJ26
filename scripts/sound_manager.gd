extends Node

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

const SOUNDS: Dictionary[String, AudioStream] = {
	"dying-bear": preload("res://art/sounds/dying-bear.mp3"),
	"dying-ocelot": preload("res://art/sounds/dying-ocelot.mp3"),
	"dying-parrot": preload("res://art/sounds/dying-parrot.mp3"),
	"eating-bear": preload("res://art/sounds/eating-bear.mp3"),
	"eating-beaver": preload("res://art/sounds/eating-beaver.mp3"),
	"eating-ocelot": preload("res://art/sounds/eating-ocelot.mp3"),
	"eating-parrot": preload("res://art/sounds/eating-parrot.mp3"),
	"parrot": preload("res://art/sounds/parrot.mp3"),
	"wave": preload("res://art/sounds/wave.mp3"),
}

const SOUNDS_MAPPING: Dictionary[String, Array] = {
	"bear_beaver": ["eating-bear"],
	"bear_berries_bush": ["eating-bear"],
	"bear_growth": [],
	"bear_starve": [],
	"beaver_coconut_tree": ["eating-beaver"],
	"beaver_growth": [],
	"beaver_starve": [],
	"berries_bush_growth": [],
	"berries_bush_ocelot": ["eating-ocelot"],
	"coconut_tree_bear": ["dying-bear"],
	"coconut_tree_growth": [],
	"ocelot_growth": [],
	"ocelot_parrot": ["dying-parrot", "eating-ocelot"],
	"ocelot_starve": ["dying-ocelot"],
	"parrot_berries_bush": ["eating-parrot"],
	"parrot_coconut_tree": [],
	"parrot_growth": [],
	"parrot_starve": ["dying-parrot"],
	"parrot_tired": ["dying-parrot"],
}


func play_sound():
	var state = {
		"dying-bear": 0,
		"dying-ocelot": 0,
		"dying-parrot": 0,
		"eating-bear": 0,
		"eating-beaver": 0,
		"eating-ocelot": 0,
		"eating-parrot": 0,
	}

	var sound_name

	for id in Logbook.entries:
		for sound in SOUNDS_MAPPING[id]:
			state[sound]  += Logbook.entries[id].count

	if state["dying-bear"] > 0:
		sound_name = "dying-bear"
	else:
		var max_ids = []
		var max_value = 0
		for id in state:
			if max_value == state[id]:
				max_ids.append(id)
			elif max_value < state[id]:
				max_ids = [id]
				max_value = state[id]
		
		sound_name = max_ids.pick_random()

	$SFX.stream = SOUNDS[sound_name]
	$SFX.play()


func _on_timer_timeout():
	var rand: int = rng.randi_range(1, 60)
	if rand == 1:
		$BackgroundSounds.stream = SOUNDS["parrot"]
		$BackgroundSounds.play()
	elif rand == 2:
		$BackgroundSounds.stream = SOUNDS["wave"]
		$BackgroundSounds.play()
