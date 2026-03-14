extends Entity
class_name Bear

func update_state(state: State.TemporaryState, _cycle: int):
	if !state.require_destruct(State.BERRIES_BUSH.name()) and !state.require_destruct(State.BEAVER.name()):
		state.destruct(name())
	pass

func name() -> String:
	return "bear"

func reproduction_stats() -> ReproductionStats:
	return ReproductionStats.init(1.5, 2, 2)
