extends Entity
class_name CoconutTree

func update_state(state: State.TemporaryState, cycle: int):
	if randi() % 30 == 0:
		state.destruct(State.BEAR.name())
	pass

func name() -> String:
	return "coconut_tree"

func reproduction_stats() -> ReproductionStats:
	return ReproductionStats.init(randf_range(1.2, 1.4), 1, 2)
