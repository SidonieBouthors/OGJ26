extends Node

class_name Entity

func update_state(_state: State.TemporaryState, _cycle: int):
	pass

func name() -> String:
	return "entity"

func reproduction_stats() -> ReproductionStats:
	return ReproductionStats.init(1, -1, 0)

class ReproductionStats:
	var multiplier: float
	var frequency: int
	var minimum_count: int

	static func init(multiplier: float, frequency: int, minimum_count: int) -> ReproductionStats:
		var stats = ReproductionStats.new()
		stats.multiplier = multiplier
		stats.frequency = frequency
		stats.minimum_count = minimum_count
		return stats
		

	func apply(initial: int, cycle: int) -> int:
		if initial < minimum_count or cycle % frequency != 0:
			return initial

		return floorf(initial * multiplier) as int
