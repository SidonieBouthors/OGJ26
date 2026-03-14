extends Entity
class_name CoconutTree

func update_state(state: State.TemporaryState, cycle: int):
	if randi() % 30 == 0:
		state.destruct(State.BEAR.name())
	pass

func name() -> String:
	return "coconut_tree"

func reproduction_stats() -> ReproductionStats:
	return ReproductionStats.init(1.5, 5, 1)
