extends Entity
class_name Parrot

func update_state(state: State.TemporaryState, _cycle: int):
	if state.state[State.BERRIES_BUSH].available == 0 \
		|| state.state[State.COCONUT_TREE].available == 0:
		state.die(self)
	else:
		state.require(self, State.BERRIES_BUSH, "ate")
		state.require(self, State.COCONUT_TREE, "perched on")

	pass

func name() -> String:
	return "parrot"
func display_name(plural: bool):
	return super(plural) if plural else "parrot"

func crate_quantity() -> Array:
	return [1, 2, 3]


func texture() -> CompressedTexture2D:
	return preload("res://art/sprites/entities/parrot.png")

func reproduction_stats() -> ReproductionStats:
	return ReproductionStats.init(randf_range(1.5, 2.5), 1, 2)
