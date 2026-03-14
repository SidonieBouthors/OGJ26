extends PanelContainer
class_name MainMenu

func on_play():
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func on_quit():
	get_tree().quit()
