extends Node

class Entry:
	var count: int = 0
	var category: Category

	enum Category {
		Growth,
		Death,
		Neutral,
	}

	func _init(co: int, ca: Category):
		self.count = co
		self.category = ca

var entries: Dictionary[String, Entry]

func add_2ents(victimizer: Entity, victim: Entity):
	add("%s_%s" % [victimizer.name(), victim.name()], 1, Entry.Category.Neutral)

func add(id: String, count: int, category: Entry.Category):
	if id in entries:
		entries[id].count += count
	else:
		entries[id] = Entry.new(count, category)
