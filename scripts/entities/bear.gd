extends Entity
class_name Bear

func update_state(state: State.TemporaryState, _cycle: int):
	if randi() % 2 == 0 and !state.require_destruct(State.BERRIES_BUSH.name()) and !state.require_destruct(State.BEAVER.name()):
		state.destruct(name())
	pass

func name() -> String:
	return "bear"

func crate_quantity() -> Array:
	return [1]

func reproduction_stats() -> ReproductionStats:
	return ReproductionStats.init(randf_range(1.3, 1.7), 1, 2)
