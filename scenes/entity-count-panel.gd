extends PanelContainer

var entity_counter = preload("res://scenes/entity-count.tscn")

@onready var vbox = %EntityCountVBox

func _ready():
	for species : String in Global.entities.keys():
		add_entity_counter(species)

func add_entity_counter(species: String):
	var new_entity_counter : EntityCounter = entity_counter.instantiate()
	vbox.add_child(new_entity_counter)
	new_entity_counter.species = species
	new_entity_counter.update()

func update():
	vbox.get_children().map(func (entity_counter) : entity_counter.update())
