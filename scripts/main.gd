extends Node2D

const NAME_TO_ID: Dictionary[String, int] = { "parrot" : 0, "berries_bush": 1, "coconut_tree": 2, "beaver": 3, "bear": 4, "ocelot": 5 } 
var cycle : int = 0

@onready var ISLAND_CELLS = $Island.get_used_cells_by_id(0)
var timer: Timer

func _ready():
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 5.0
	timer.autostart = true
	timer.timeout.connect(next_cycle)
	timer.one_shot = false
	timer.start()

func next_cycle() -> void:
	print("next_cycle")
	var current_positions : Array[Vector2i] = $Entities.get_used_cells()
	var available_positions : Array[Vector2i] = ISLAND_CELLS.duplicate()
	for pos in current_positions:
		available_positions.erase(pos)
	
	var prev_state : Dictionary[String, int] = Global.state.duplicate()
	Global.cycle()
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
		
		
	
	
