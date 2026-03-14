extends MarginContainer

@export var entity_texture: Texture2D:
	set(value):
		entity_texture = value
		if is_inside_tree():
			%EntityTextureRect.texture = value
@export var amount: int = 0:
	set(value):
		amount = value
		if is_inside_tree():
			%EntityCountLabel.text = value

func _ready():
	%EntityTextureRect.texture = entity_texture
	%EntityCountLabel.text = str(amount)
