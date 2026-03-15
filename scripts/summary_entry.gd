extends HBoxContainer
class_name SummaryEntry

@export var amount: int
@export var sprite_frames: SpriteFrames
@export var color: Color = Color.WHITE

func set_sprite_frames(sp: SpriteFrames):
	sprite_frames = sp
	if is_inside_tree():
		%Animation.sprite_frames = sp


func set_amount(n: int):
	amount = n
	if is_inside_tree():
		%Count.text = str(n)

func set_color(c: Color):
	color = c
	if is_inside_tree():
		%Count.add_theme_color_override("font_color", color)

func _ready():
	%Animation.sprite_frames = sprite_frames
	%Count.text = str(amount)
	%Count.add_theme_color_override("font_color", color)

	%Animation.play("default")
