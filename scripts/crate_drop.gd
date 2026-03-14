extends CanvasLayer

@onready var crate1: Crate = $CenterContainer/PanelContainer/MarginContainer/HBoxContainer/Crate1
@onready var crate2: Crate = $CenterContainer/PanelContainer/MarginContainer/HBoxContainer/Crate2


func set_crate_species(species1: String, species2: String):
	crate1.set_species(species1)
	crate2.set_species(species2)

func set_quantities(n1: int, n2: int):
	crate1.set_quantity(n1)
	crate2.set_quantity(n2)
