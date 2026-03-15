extends MarginContainer
class_name EntityCounter

@export var species: String

@export var entity_texture: Texture2D


@export var amount: int = 0

func set_texture(tex: CompressedTexture2D):
	entity_texture = tex
	if is_inside_tree():
		%EntityTextureRect.texture = tex


func set_amount(n: int):
	amount = n
	if is_inside_tree():
		%EntityCountLabel.text = str(n)


func _ready():
	%EntityTextureRect.texture = entity_texture
	%EntityCountLabel.text = str(amount)


func update():
	set_texture(Global.entities[species].texture())
	set_amount(Global.state[species])
