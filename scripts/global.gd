extends Node
class_name State

static var COCONUT_TREE = CoconutTree.new()
static var BERRIES_BUSH = BerriesBush.new()
static var PARROT = Parrot.new()
static var BEAVER = Beaver.new()
static var OCELOT = Ocelot.new()
static var BEAR = Bear.new()

var entities: Dictionary[String, Entity] = [
	COCONUT_TREE,
	BERRIES_BUSH,
	PARROT,
	BEAVER,
	OCELOT,
	BEAR
].reduce(func(acc, ent):
	acc[ent.name()] = ent
	return acc
, {} as Dictionary[String, Entity])

var state: Dictionary[String, int] = entities.keys().reduce(func(acc, ent_name):
	acc[ent_name] = 3
	return acc
, {} as Dictionary[String, int])
var cycle_number = 0
#
#func _ready() -> void:
	#state["parrot"] = 2
	#state["coconut_tree"] = 4
	#state["berries_bush"] = 4
	
func apply_constraints():
	var timeline: Array[Entity] = state.keys().reduce(func(acc: Array[Entity], ent_name):
		var ent_arr = []
		ent_arr.resize(state[ent_name])
		ent_arr.fill(entities[ent_name])
		acc.append_array(ent_arr)
		return acc
	, [] as Array[Entity])
	timeline.shuffle()

	var temp = TemporaryState.new()
	temp.state = state.keys().reduce(func(acc, ent_name):
		var ent_temp = EntityTemporaryState.new()
		ent_temp.alive = state[ent_name]
		ent_temp.available = state[ent_name]
		acc[ent_name] = ent_temp
		return acc
	, {} as Dictionary[String, EntityTemporaryState])

	for ent: Entity in timeline:
		ent.update_state(temp, cycle_number)

	state = temp.state.keys().reduce(func(acc, ent_name):
		acc[ent_name] = temp.state[ent_name].alive
		return acc
	, {} as Dictionary[String, int])

func reproduce():
	for ent_name in state:
		state[ent_name] = entities[ent_name].reproduction_stats().apply(state[ent_name], cycle_number)

	cycle_number += 1

class TemporaryState:
	var state: Dictionary[String, EntityTemporaryState]

	func require_destruct(name: String) -> bool:
		if state[name].available > 0:
			assert(state[name].alive > 0)

			state[name].available -= 1
			state[name].alive -= 1

			return true

		return false

	func require(name: String) -> bool:
		if state[name].available > 0:
			state[name].available -= 1
			return true

		return false

	func destruct(name: String):
		if state[name].alive > 0:
			state[name].alive -= 1
			state[name].available -= 1
		pass

class EntityTemporaryState:
	var alive: int
	var available: int
