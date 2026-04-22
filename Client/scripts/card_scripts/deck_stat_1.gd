extends CardStats

func on_play(_position: int) -> void:
	Constants.modify_private_stats.emit('A', 1, Constants.PrivateTarget.DECK, 10)
