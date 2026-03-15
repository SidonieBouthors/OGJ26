extends Node2D

@onready var NAME_TO_ID: Dictionary[String, int] = {State.PARROT.name(): 0, State.BERRIES_BUSH.name(): 1, State.COCONUT_TREE.name(): 2, State.BEAVER.name(): 3, State.BEAR.name(): 4, State.OCELOT.name(): 5}
@onready var ISLAND_CELLS: Array[Vector2i] = $Island.get_used_cells_by_id(0)

var available_positions: Array[Vector2i]
var prev_state: Dictionary[String, int]

func _ready():
	Global.reset()
	%CycleCounter.update_counter()
	Global.max_entities = ISLAND_CELLS.size()
	available_positions = ISLAND_CELLS.duplicate()
	$Entities.clear()
	$CanvasLayer/EntityCountPanel.update()
	for species: String in Global.state:
		for i in range(Global.state[species]):
			var new_pos: Vector2i = available_positions.pick_random()
			available_positions.erase(new_pos)
			$Entities.set_cell(new_pos, NAME_TO_ID[species], Vector2i(0, 0))
	prev_state = Global.state.duplicate()
	
	Global.victory.connect(func(): $Victory.visible = true)

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if $CanvasLayer/CenterContainer/Summary.visible == true:
			$CanvasLayer/CenterContainer/Summary.visible = false
			$CanvasLayer/MarginContainer1/NextStateButton.disabled = false

		else:
			get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	if $CanvasLayer/CenterContainer/Summary.visible == true:
		$CanvasLayer/MarginContainer1/NextStateButton.disabled = true

func next_cycle():
	Global.reproduce()
	Global.apply_constraints()
	animate()
	%CycleCounter.update_counter()
	$CanvasLayer/MarginContainer1/NextStateButton.disabled = false
	if Global.cycle_number % 3 == 1:
		spawn_crate()


func animate() -> void:
	for species: String in Global.state:
		var prev_count: int = prev_state[species]
		var diff = Global.state[species] - prev_count
		if diff > 0:
			for i in range(diff):
				if available_positions.is_empty(): break
				var new_pos: Vector2i = available_positions.pick_random()
				available_positions.erase(new_pos)
				$Entities.set_cell(new_pos, NAME_TO_ID[species], Vector2i(0, 0))
		elif diff < 0:
			var current_entity_positions: Array[Vector2i] = $Entities.get_used_cells_by_id(NAME_TO_ID[species])
			current_entity_positions.shuffle()
			for i in range(-diff):
				var removed_pos: Vector2i = current_entity_positions.pop_back()
				$Entities.erase_cell(removed_pos)
				available_positions.append(removed_pos)
			
	prev_state = Global.state.duplicate()
	$CanvasLayer/EntityCountPanel.update()

func find_crate_quantity(species: String) -> int:
	var entity = Global.entities[species]
	return entity.crate_quantity().pick_random()

func spawn_crate(num_options: int = 3):
	var species_list: Array[String] = []
	var quantities: Array[int] = []
	for i in range(num_options):
		var new_species = Global.state.keys().pick_random()
		while (new_species in species_list):
			new_species = Global.state.keys().pick_random()
		species_list.append(new_species)
		quantities.append(find_crate_quantity(new_species))
	$CrateDrop.set_crates([species_list, quantities] as Array[Array])
	$CrateDrop.visible = true
	get_tree().paused = true


func _on_crate_chosen(species: String, quantity: int):
	quantity = min(Global.max_entities - Global.count_total(), quantity)
	Global.state[species] = Global.state[species] + quantity
	animate()


func _on_next_state_button_pressed():
	if $CanvasLayer/CenterContainer/Summary.visible == true:
		$CanvasLayer/CenterContainer/Summary.visible = false
	$CanvasLayer/MarginContainer1/NextStateButton.disabled = true
	next_cycle()


func _on_restart_button_pressed():
	get_tree().reload_current_scene()


func _on_summary_toggle_next_button():
	$CanvasLayer/MarginContainer1/NextStateButton.disabled = not $CanvasLayer/MarginContainer1/NextStateButton.disabled
