extends Entity
class_name BerriesBush

func update_state(state: State.TemporaryState, _cycle: int):
	if randi() % 5 == 0:
		state.destruct(State.OCELOT.name())
	pass

func name() -> String:
	return "berries_bush"

func reproduction_stats() -> ReproductionStats:
	return ReproductionStats.init(1.5, 5, 1)
