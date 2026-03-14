extends Entity
class_name Parrot

func update_state(state: State.TemporaryState, _cycle: int):
	if !state.require(State.BERRIES_BUSH.name()):
		return
	state.require(State.COCONUT_TREE.name())
	pass

func name() -> String:
	return "parrot"

func reproduction_stats() -> ReproductionStats:
	return ReproductionStats.init(1.5, 2, 2)
