extends Node2D

@onready var NAME_TO_ID: Dictionary[String, int] = { State.PARROT.name() : 0, State.BERRIES_BUSH.name() : 1, State.COCONUT_TREE.name(): 2, State.BEAVER.name(): 3, State.BEAR.name(): 4, State.OCELOT.name(): 5 } 
@onready var ISLAND_CELLS : Array[Vector2i] = $Island.get_used_cells_by_id(0)

var available_positions : Array[Vector2i]
var prev_state: Dictionary[String, int] 

func _ready():
	Global.max_entities = ISLAND_CELLS.size()
	available_positions = ISLAND_CELLS.duplicate()
	$Entities.clear()
	for species : String in Global.state:
		for i in range(Global.state[species]):
			var new_pos : Vector2i = available_positions.pick_random()
			available_positions.erase(new_pos)
			$Entities.set_cell(new_pos, NAME_TO_ID[species], Vector2i(0, 0))
	prev_state = Global.state.duplicate()

func next_cycle():
	Global.reproduce()
	animate()
	#await get_tree().create_timer(2.0).timeout
	Global.apply_constraints()
	animate()
	$NextStateButton.disabled = false
	if Global.cycle_number % 5 == 1:
		spawn_crate()


func animate() -> void:
	for species : String in Global.state:
		var prev_count : int = prev_state[species]
		var diff = Global.state[species] - prev_count
		if diff > 0:
			for i in range(diff):
				if available_positions.is_empty(): break
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
				
				#DEBUG
		var num_tiles = $Entities.get_used_cells_by_id(NAME_TO_ID[species]).size()
		var actual = Global.state[species]
		if actual != num_tiles:
			print("number of tiles with ", species,": ", num_tiles, ". Expected: ", actual )
			#END DEBUG
			
	prev_state = Global.state.duplicate()
	$Counter/EntityCountPanel.update()

func find_crate_quantity(species: String) -> int:
	var entity = Global.entities[species]
	return entity.crate_quantity().pick_random()

func spawn_crate():
	var species1 : String = Global.state.keys().pick_random()
	var species2 : String = Global.state.keys().pick_random()
	while species2 == species1:
		species2 = Global.state.keys().pick_random()
		
	var n1 = find_crate_quantity(species1)
	var n2 = find_crate_quantity(species2)
	$CrateDrop.set_crate_species(species1, species2)
	$CrateDrop.set_quantities(n1, n2)
	$CrateDrop.visible = true
	get_tree().paused = true


func _on_crate_chosen(species, quantity):
	quantity = min(Global.max_entities - Global.count_total(), quantity)
	Global.state[species] = Global.state[species] + quantity
	animate()


func _on_next_state_button_pressed():
	$NextStateButton.disabled = true
	next_cycle()
