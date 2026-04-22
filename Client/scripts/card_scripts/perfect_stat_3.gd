extends CardStats

func on_play(position: int) -> void:
	Constants.modify_board_stats.emit('H', 1, Constants.BoardTarget.OWNER, position)
	Constants.modify_board_stats.emit('H', -1, Constants.BoardTarget.OPPONENT, position)
