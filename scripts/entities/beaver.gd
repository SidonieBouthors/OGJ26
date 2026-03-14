extends Entity
class_name Beaver

func update_state(state: State.TemporaryState, _cycle: int):
	if !state.require_destruct(State.COCONUT_TREE.name()):
		state.destruct(name())
	pass

func name() -> String:
	return "beaver"

func reproduction_stats() -> ReproductionStats:
	return ReproductionStats.init(1.5, 2, 2)
