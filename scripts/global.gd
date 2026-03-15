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
	acc[ent_name] = 0
	return acc
, {} as Dictionary[String, int])

var cycle_number = 0
var victory_condition_met_count = 0

var logbook: Logbook = Logbook.new()

var max_entities: int

func _ready() -> void:
	#state["parrot"] = 10
	#state["coconut_tree"] = 10
	#state["berries_bush"] = 10
	#state["bear"] = 3
	#state["beaver"] = 4
	#state["ocelot"] = 6
	state["parrot"] = 3
	state["coconut_tree"] = 3
	state["berries_bush"] = 4
	state["bear"] = 0
	state["beaver"] = 0
	state["ocelot"] = 0

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
		acc[entities[ent_name]] = ent_temp
		return acc
	, {} as Dictionary[Entity, EntityTemporaryState])

	for ent: Entity in timeline:
		ent.update_state(temp, cycle_number)

	state = temp.state.keys().reduce(func(acc, ent):
		acc[ent.name()] = temp.state[ent].alive
		return acc
	, {} as Dictionary[String, int])


	Global.logbook.add_log("Logs for cycle %d" % cycle_number)
	Global.logbook.process_pending()

	check_victory()
	cycle_number += 1

func reproduce():
	var ideal_state: Dictionary[String, int] = state.duplicate()
	for ent_name in ideal_state:
		ideal_state[ent_name] = entities[ent_name].reproduction_stats().apply(ideal_state[ent_name], cycle_number)
	#The following code ensures that the entities that wish to reproduce do it fairly within
	#the constraints of the island
	if (count_total(ideal_state) > max_entities):
		var ideal_increase: Dictionary[String, int] = sub_dicts(ideal_state, state)
		var current_count: int = count_total(state)
		var ratio: float = (max_entities - current_count) as float / count_total(ideal_increase)

		for species in ideal_increase:
			var growth = max((floorf(ideal_increase[species] * ratio) as int) - 1, 0)
			ideal_increase[species] = growth
			Global.logbook.add_pending(
				"%s_growth" % species,
				Logbook.CountedEntityEntry.new(
					"{count} {counted} were born",
					 {"counted": entities[species]}
			))

		ideal_state = add_dicts(state, ideal_increase)

		
		print("actual count_total:", count_total(ideal_state))
		#DEBUG
		if count_total(ideal_state) > 200:
			pass

	
	for e in ideal_state:
		if ideal_state[e] > state[e]:
			Global.logbook.add_pending(
				"%s_growth" % e,
				Logbook.CountedEntityEntry.new(
					"{count} {counted} were born",
					{
						"counted": entities[e],
						"count": ideal_state[e] - state[e]
					}
			))
	
	state = ideal_state


func count_total(temp_state: Dictionary[String, int] = state) -> int:
	return temp_state.values().reduce(func(acc, count):
		return acc + count)

func check_victory():
	if state.values().all(func(c): return c >= 3):
		print("condition met")
		victory_condition_met_count += 1
	else:
		victory_condition_met_count = 0

	if victory_condition_met_count >= 3:
		print("Victory!!!!")


class TemporaryState:
	var state: Dictionary[Entity, EntityTemporaryState]

	func require_destruct(ent: Entity, vict: Entity, action: String) -> bool:
		if state[vict].available > 0:
			assert(state[vict].alive > 0)

			state[vict].available -= 1
			state[vict].alive -= 1
			
			Global.logbook.add_pending_2ents(ent, vict, action)

			return true

		return false

	func require(ent: Entity, vict: Entity, action: String) -> bool:
		if state[vict].available > 0:
			state[vict].available -= 1
			Global.logbook.add_pending_2ents(ent, vict, action)
			return true

		return false

	func destruct(ent: Entity, vict: Entity, action: String):
		if state[vict].alive > 0:
			state[vict].alive -= 1
			state[vict].available -= 1
			Global.logbook.add_pending_2ents(ent, vict, action)
		pass
	
	func die(ent: Entity):
		assert(state[ent].alive > 0)
		state[ent].alive -= 1
		state[ent].available -= 1
		Global.logbook.pending_entries["%s_death" % ent.name()] = Logbook.CountedEntityEntry.new("{count} {counted} died", {"counted": ent})

class Logbook:
	var entries: Array[String]
	var pending_entries: Dictionary[String, Entry]
	
	class Entry:
		var template: String
		var params: Dictionary
		func _init(t: String, p: Dictionary):
			self.template = t
			self.params = p
		func format() -> String:
			return template.format(params)

	class CountedEntityEntry extends Entry:
		func _init(t: String, p: Dictionary):
			if !"count" in p:
				p.count = 1
			super (t, p)
		func format() -> String:
			params.counted = params.counted.display_name(params.count > 1)
			return super ()


	func add_pending_2ents(victimizer: Entity, victim: Entity, action: String):
		add_pending("%s_%s" % [victimizer.name(), victim.name()], \
			CountedEntityEntry.new("{victimizer} {action} {count} {counted}", {
				"victimizer": victimizer.display_name(true).capitalize(),
				"action": action,
				"counted": victim,
			}))

	func add_pending(id: String, entry: Entry):
		if id in pending_entries:
			var params = pending_entries[id].params
			if "count" in params:
				params["count"] += 1
		else:
			pending_entries[id] = entry

	func add_log(entry: String):
		print(entry)
		entries.append(entry)

	func process_pending():
		for entry in pending_entries.values():
			add_log(entry.format())
		pending_entries.clear()

class EntityTemporaryState:
	var alive: int
	var available: int


func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()


func sub_dicts(a: Dictionary[String, int], b: Dictionary[String, int]) -> Dictionary[String, int]:
	var result = a.duplicate()
	for key in a:
		result[key] = a[key] - b.get(key, 0)
	return result

func add_dicts(a: Dictionary[String, int], b: Dictionary[String, int]) -> Dictionary[String, int]:
	var result = a.duplicate()
	for key in a:
		result[key] = a[key] + b.get(key, 0)
	return result
