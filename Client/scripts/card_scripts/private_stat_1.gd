extends CardStats

func on_play(_position: int) -> void:
	Constants.modify_private_stats.emit('H', 1, Constants.PrivateTarget.HAND)
