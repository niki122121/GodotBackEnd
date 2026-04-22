extends CardStats

func on_play(position: int) -> void:
	Constants.modify_board_stats.emit('H', 1, Constants.BoardTarget.OWNER_LEFT, position)
	Constants.modify_board_stats.emit('A', 1, Constants.BoardTarget.OWNER_RIGHT, position)
