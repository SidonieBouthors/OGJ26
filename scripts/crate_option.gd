extends AspectRatioContainer
class_name Crate

var species: String
var quantity: int

signal chose_crate(species: String, quantity: int)

func set_species(spe: String):
	species = spe
	$MarginContainer/TextureRect.texture = Global.entities[spe].texture()

func set_quantity(n: int):
	quantity = n
	$Control/NinePatchRect/Label.text = "x" + str(n)


func _on_button_pressed():
	chose_crate.emit(species, quantity)
