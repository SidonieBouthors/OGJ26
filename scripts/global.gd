extends Node
class_name State

static var COCONUT_TREE = CoconutTree.new()
static var BERRIES_BUSH = BerriesBush.new()
static var PARROT = Parrot.new()
static var BEAVER = Beaver.new()
static var OCELOT = Ocelot.new()
static var BEAR = Bear.new()

var available_entities: Dictionary[String, Entity] = [
	COCONUT_TREE,
	BERRIES_BUSH,
	PARROT,
	BEAVER,
	OCELOT,
	BEAR
].reduce(func(acc, ent):
	acc[ent.name()] = ent
	return acc
, {})

var state: Dictionary[String, int] = available_entities.keys().reduce(func(acc, ent_name):
	acc[ent_name] = 0
	return acc
, {})
var cycle_number = 0

func cycle():
	var entities: Array[Entity] = state.keys().reduce(func(acc: Array[Entity], ent_name):
		var ent_arr = []
		ent_arr.resize(state[ent_name])
		ent_arr.fill(available_entities[ent_name])
		acc.append_array(ent_arr)
	, [])
	entities.shuffle()

	var temp = TemporaryState.new()
	temp.state = state.keys().reduce(func(acc, ent_name):
		var ent_temp = EntityTemporaryState.new()
		ent_temp.alive = state[ent_name]
		ent_temp.available = state[ent_name]
		acc[ent_name] = ent_temp
	, {})

	for ent: Entity in entities:
		ent.update_state(temp, cycle_number)

	cycle_number += 1

	state = temp.state.keys().reduce(func(acc, ent_name):
		acc[ent_name] = temp.state[ent_name].alive
		return acc
	, {})

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
