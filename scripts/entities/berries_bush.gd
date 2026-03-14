extends Entity
class_name BerriesBush

func update_state(state: State.TemporaryState, _cycle: int):
	if randi() % 10  == 0:
		state.destruct(State.OCELOT.name())
	pass

func name() -> String:
	return "berries_bush"

func reproduction_stats() -> ReproductionStats:
	return ReproductionStats.init(randf_range(1.1, 1.3), 1, 2)
