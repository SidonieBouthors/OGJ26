extends Entity
class_name Ocelot

func update_state(state: State.TemporaryState, _cycle: int):
	state.require_destruct(State.PARROT.name())

func name() -> String:
	return "ocelot"

func reproduction_stats() -> ReproductionStats:
	return ReproductionStats.init(1.5, 2, 2)
