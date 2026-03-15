extends Control
class_name MainMenu


func _ready():
	$Background.autoplay

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()


func on_play():
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func on_quit():
	get_tree().quit()
