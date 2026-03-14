extends Entity
class_name Parrot

func update_state(state: State.TemporaryState, _cycle: int):
	if state.state[State.BERRIES_BUSH.name()].available == 0 \
		|| state.state[State.COCONUT_TREE.name()].available == 0:
		state.destruct(name())
	else:
		state.require(State.BERRIES_BUSH.name())
		state.require(State.COCONUT_TREE.name())

	pass

func name() -> String:
	return "parrot"

func reproduction_stats() -> ReproductionStats:
	return ReproductionStats.init(randf_range(1.5, 2.5), 1, 2)
