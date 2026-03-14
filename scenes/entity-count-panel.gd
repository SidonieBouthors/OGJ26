extends PanelContainer

var entity_counter = preload("res://scenes/entity-count.tscn")

@onready var vbox = %VBoxContainer

func add_entity_counter():
	var new_entity_counter = entity_counter.instantiate()
	# NEED TO SET THE ENTITY TEXTURE AND AMOUNT EXPORTED
	# PROPERTIES OF THE SCENE HERE
	vbox.add_child(new_entity_counter)
