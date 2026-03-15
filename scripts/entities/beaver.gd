extends Entity
class_name Beaver

func update_state(state: State.TemporaryState, _cycle: int):
	if randi() % 2 == 0 and !state.require_destruct(State.COCONUT_TREE.name()):
		state.destruct(name())
	pass

func name() -> String:
	return "beaver"

func crate_quantity() -> Array:
	return [1, 2, 3]

func texture() -> CompressedTexture2D:
	return preload("res://art/sprites/entities/beaver.png")

func reproduction_stats() -> ReproductionStats:
	return ReproductionStats.init(randf_range(1.3, 1.7), 1, 2)
