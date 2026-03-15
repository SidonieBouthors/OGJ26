extends Node

var entries: Dictionary[String, int]

func add_2ents(victimizer: Entity, victim: Entity):
	add("%s_%s" % [victimizer.name(), victim.name()], 1)

func add(id: String, count: int):
	if id in entries:
		entries[id] += count
	else:
		entries[id] = count
