extends PanelContainer

const ENTRY_SCENE = preload("res://scenes/summary_entry.tscn")

const SPRITE_FRAMES: Dictionary[String, SpriteFrames] = {
	"bear_beaver": preload("res://art/sprites/entities/animations/bear_beaver.tres"),
	"bear_berries_bush": preload("res://art/sprites/entities/animations/bear_berries_bush.tres"),
	"bear_growth": preload("res://art/sprites/entities/animations/bear_growth.tres"),
	"bear_starve": preload("res://art/sprites/entities/animations/bear_starve.tres"),
	"beaver_coconut_tree": preload("res://art/sprites/entities/animations/beaver_coconut_tree.tres"),
	"beaver_growth": preload("res://art/sprites/entities/animations/beaver_growth.tres"),
	"beaver_starve": preload("res://art/sprites/entities/animations/beaver_starve.tres"),
	"berries_bush_growth": preload("res://art/sprites/entities/animations/berries_bush_growth.tres"),
	"berries_bush_ocelot": preload("res://art/sprites/entities/animations/berries_bush_ocelot.tres"),
	"coconut_tree_bear": preload("res://art/sprites/entities/animations/coconut_tree_bear.tres"),
	"coconut_tree_growth": preload("res://art/sprites/entities/animations/coconut_tree_growth.tres"),
	"ocelot_growth": preload("res://art/sprites/entities/animations/ocelot_growth.tres"),
	"ocelot_parrot": preload("res://art/sprites/entities/animations/ocelot_parrot.tres"),
	"ocelot_starve": preload("res://art/sprites/entities/animations/ocelot_starve.tres"),
	"parrot_berries_bush": preload("res://art/sprites/entities/animations/parrot_berries_bush.tres"),
	"parrot_coconut_tree": preload("res://art/sprites/entities/animations/parrot_coconut_tree.tres"),
	"parrot_growth": preload("res://art/sprites/entities/animations/parrot_growth.tres"),
	"parrot_starve": preload("res://art/sprites/entities/animations/parrot_starve.tres"),
	"parrot_tired": preload("res://art/sprites/entities/animations/parrot_tired.tres"),
}

var COLORS: Dictionary[Logbook.Entry.Category, Color] = {
	Logbook.Entry.Category.Growth: Color.from_string("#25b700", Color.GREEN),
	Logbook.Entry.Category.Death: Color.from_string("#A70000", Color.RED),
	Logbook.Entry.Category.Neutral: Color.from_string("#ecd3ac", Color.WHITE),
}

func _ready():
	Global.cycle_done.connect(_on_cycle)

func _on_cycle():
	%Grid.get_children().map(func(c): c.queue_free())
	var to_show = false

	for id in Logbook.entries:
		if id in SPRITE_FRAMES:
			var entry = ENTRY_SCENE.instantiate()
			entry.set_amount(Logbook.entries[id].count)
			entry.set_color(COLORS[Logbook.entries[id].category])
			entry.set_sprite_frames(SPRITE_FRAMES[id])
			%Grid.add_child(entry)
			to_show = true
		else:
			print("animation id not found: ", id)

	SoundManager.play_sound()
	Logbook.entries.clear()

	if to_show:
		visible = true

func _on_hide():
	visible = false
