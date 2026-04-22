extends CardStats

func on_play(position: int) -> void:
	Constants.modify_board_from_private_stats.emit('H', 4, Constants.BoardTarget.SELF, position,
			Constants.PrivateTarget.DECK, 'H', 20, 10)
