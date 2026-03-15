extends CanvasLayer

@onready var container = $CenterContainer/PanelContainer/MarginContainer/HBoxContainer

var crate_option = preload("res://scenes/crate-option.tscn")

signal chose_crate(species: String, quantity: int)


func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		close()

func set_crates(contents: Array[Array]):
	container.get_children().map(func (crate): crate.queue_free())
	var species_list : Array = contents[0]
	var quantities : Array = contents[1]
	for i in range(species_list.size()):
		var crate : Crate = crate_option.instantiate()
		container.add_child(crate)
		crate.chose_crate.connect(_on_crate_chosen)
		crate.set_species(species_list[i])
		crate.set_quantity(quantities[i])


func _on_crate_chosen(species: String, quantity: int):
	chose_crate.emit(species, quantity)
	close()

func close():
	visible = false
	get_tree().paused = false
