extends Entity
class_name CoconutTree

func update_state(state: State.TemporaryState, _cycle: int):
	if randi() % 30 == 0:
		state.destruct(self, State.BEAR)
	pass

func name() -> String:
	return "coconut_tree"
func display_name(plural: bool):
	return super(plural) if plural else "coconut tree"

func crate_quantity() -> Array:
	return [2, 3]


func texture() -> CompressedTexture2D:
	return preload("res://art/sprites/entities/coconut_tree.png")

func reproduction_stats() -> ReproductionStats:
	return ReproductionStats.init(randf_range(1.0, 1.1), 1, 1)
