extends AspectRatioContainer
class_name Crate

var SPECIES_TEXTURES : Dictionary[String, CompressedTexture2D] = { State.PARROT.name() : preload("res://art/sprites/tiles/parrot.png"), State.BERRIES_BUSH.name() : preload("res://art/sprites/tiles/berries_bush.png"), State.COCONUT_TREE.name(): preload("res://art/sprites/tiles/coconut_tree.png"), State.BEAVER.name(): preload("res://art/sprites/tiles/beaver.png"), State.BEAR.name(): preload("res://art/sprites/tiles/bear.png"), State.OCELOT.name(): preload("res://art/sprites/tiles/ocelot.png") } 


var species: String
var quantity: int

signal chose_crate(species: String, quantity: int)

func set_species(spe: String):
	species = spe
	$MarginContainer/TextureRect.texture = SPECIES_TEXTURES[spe]

func set_quantity(n: int):
	quantity = n
	$Control/NinePatchRect/Label.text = str(n)


func _on_button_pressed():
	chose_crate.emit(species, quantity)
