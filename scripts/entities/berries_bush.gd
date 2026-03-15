extends Entity
class_name BerriesBush

func update_state(state: State.TemporaryState, _cycle: int):
	if randi() % 10  == 0:
		state.destruct(self, State.OCELOT)
	pass

func name() -> String:
	return "berries_bush"
func display_name(plural: bool):
	return "berry bushes" if plural else "berry bush"

func crate_quantity() -> Array:
	return [2, 3]


func texture() -> CompressedTexture2D:
	return preload("res://art/sprites/entities/berries_bush.png")

func reproduction_stats() -> ReproductionStats:
	return ReproductionStats.init(randf_range(1.0, 1.1), 1, 1)
