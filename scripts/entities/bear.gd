extends Entity
class_name Bear

func update_state(state: State.TemporaryState, _cycle: int):
	if randi() % 2 == 0 \
		and !state.require_destruct(self, State.BERRIES_BUSH, "ate") \
		and !state.require_destruct(self, State.BEAVER, "ate"):
		state.die(self)
	pass

func name() -> String:
	return "bear"
func display_name(plural: bool):
	return super(plural) if plural else "bear"

func crate_quantity() -> Array:
	return [1]

func texture() -> CompressedTexture2D:
	return preload("res://art/sprites/entities/bear.png")

func reproduction_stats() -> ReproductionStats:
	return ReproductionStats.init(randf_range(1.3, 1.7), 1, 2)
