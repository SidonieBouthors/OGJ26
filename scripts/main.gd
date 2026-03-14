extends Node2D

@onready var NAME_TO_ID: Dictionary[String, int] = { State.PARROT.name() : 0, State.BERRIES_BUSH.name() : 1, State.COCONUT_TREE.name(): 2, State.BEAVER.name(): 3, State.BEAR.name(): 4, State.OCELOT.name(): 5 } 
@onready var ISLAND_CELLS = $Island.get_used_cells_by_id(0)

var timer: Timer = Timer.new()

var available_positions : Array[Vector2i]
var prev_state: Dictionary[String, int] 

func _ready():
	available_positions = ISLAND_CELLS.duplicate()
	$Entities.clear()
	for species : String in Global.state:
		for i in range(Global.state[species]):
			var new_pos : Vector2i = available_positions.pick_random()
			available_positions.erase(new_pos)
			$Entities.set_cell(new_pos, NAME_TO_ID[species], Vector2i(0, 0))
	prev_state = Global.state.duplicate()
	

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		print("next cycle")
		Global.reproduce()
		animate()
		await get_tree().create_timer(2.0).timeout
		Global.apply_constraints()
		animate()

func animate() -> void:
	print("animating")
	for species : String in Global.state:
		var prev_count : int = prev_state[species]
		var diff = Global.state[species] - prev_count
		if diff > 0:
			for i in range(diff):
				var new_pos : Vector2i = available_positions.pick_random()
				available_positions.erase(new_pos)
				$Entities.set_cell(new_pos, NAME_TO_ID[species], Vector2i(0, 0))
		elif diff < 0:
			var current_entity_positions : Array[Vector2i] = $Entities.get_used_cells_by_id(NAME_TO_ID[species])
			current_entity_positions.shuffle()
			for i in range(-diff):
				var removed_pos : Vector2i = current_entity_positions.pop_back()
				$Entities.erase_cell(removed_pos)
				available_positions.append(removed_pos)
	prev_state = Global.state.duplicate()
