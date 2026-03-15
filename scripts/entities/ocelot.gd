extends Entity
class_name Ocelot

func update_state(state: State.TemporaryState, _cycle: int):
	if randi() % 2 == 0 and !state.require_destruct(State.PARROT.name()):
		state.destruct(name())

func name() -> String:
	return "ocelot"


func crate_quantity() -> Array:
	return [1, 2]


func texture() -> CompressedTexture2D:
	return preload("res://art/sprites/entities/ocelot.png")

func reproduction_stats() -> ReproductionStats:
	return ReproductionStats.init(randf_range(1.2, 1.5), 1, 2)
