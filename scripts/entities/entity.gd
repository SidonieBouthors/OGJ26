extends Node

class_name Entity


func update_state(_state: State.TemporaryState, _cycle: int):
	pass

func name() -> String:
	return "entity"
func display_name(plural: bool):
	if plural:
		return display_name(false) + "s"
	else:
		return ""

func crate_quantity() -> Array:
	return [1, 2, 3]

func texture() -> CompressedTexture2D:
	return load("res://art/sprites/entities/" + name() + ".png")

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

		var growth = initial * multiplier
		var population = floorf(growth) as int

		if randf_range(0.0, 1.0) <= (growth - population):
			population += 1

		return population
