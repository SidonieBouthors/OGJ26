extends CanvasLayer

func _on_quit():
	get_tree().quit()

func _on_back():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
