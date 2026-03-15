extends Node

var rng : RandomNumberGenerator = RandomNumberGenerator.new()

const SOUNDS: Dictionary[String, AudioStream] = {
"dying-bear": preload("res://art/sounds/dying-bear.mp3"), 
"dying-ocelot": preload("res://art/sounds/dying-ocelot.mp3"), 
"dying-parrot": preload("res://art/sounds/dying-parrot.mp3"),
"eating-bear": preload("res://art/sounds/eating-bear.mp3"), 
"eating-beaver": preload("res://art/sounds/eating-beaver.mp3"), 
"eating-ocelot": preload("res://art/sounds/eating-ocelot.mp3"), 
"eating-parrot": preload("res://art/sounds/eating-parrot.mp3"),
"parrot": preload("res://art/sounds/parrot.mp3"), 
"wave": preload("res://art/sounds/wave.mp3")}


func play_sound(sound_name: String):
		$SFX.stream = SOUNDS[sound_name]
		$SFX.play()


func _on_timer_timeout():
	var rand: int =  rng.randi_range(1, 60)
	if rand == 1:
		$BackgroundSounds.stream = SOUNDS["parrot"]
		$BackgroundSounds.play()
	elif rand == 2:
		$BackgroundSounds.stream = SOUNDS["wave"]
		$BackgroundSounds.play()
