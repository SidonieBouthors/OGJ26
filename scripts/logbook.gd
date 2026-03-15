extends Node

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
