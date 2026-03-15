extends Node

class_name Entity


func update_state(_state: State.TemporaryState, _cycle: int):
	pass

func name() -> String:
	return "entity"

func crate_quantity() -> Array:
	return [1, 2, 3]

func texture() -> CompressedTexture2D:
	return load("res://art/sprites/entities/" + name() +".png")

func reproduction_stats() -> ReproductionStats:
	return ReproductionStats.init(1, -1, 0)

class ReproductionStats:
	var multiplier: float
	var frequency: int
	var minimum_count: int

	static func init(m: float, f: int, c: int) -> ReproductionStats:
		var stats = ReproductionStats.new()
		stats.multiplier = m
		stats.frequency = f
		stats.minimum_count = c
		return stats
		

	func apply(initial: int, cycle: int) -> int:
		if initial < minimum_count or cycle % frequency != 0:
			return initial

		return floorf(initial * multiplier) as int
