extends CanvasLayer

@onready var crate1: Crate = $CenterContainer/PanelContainer/MarginContainer/HBoxContainer/Crate1
@onready var crate2: Crate = $CenterContainer/PanelContainer/MarginContainer/HBoxContainer/Crate2

signal chose_crate(species: String, quantity: int)


func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		close()

func set_crate_species(species1: String, species2: String):
	crate1.set_species(species1)
	crate2.set_species(species2)

func set_quantities(n1: int, n2: int):
	crate1.set_quantity(n1)
	crate2.set_quantity(n2)


func _on_crate_chosen(species: String, quantity: int):
	chose_crate.emit(species, quantity)
	close()

func close():
	visible = false
	get_tree().paused = false
