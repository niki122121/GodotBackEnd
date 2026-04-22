extends CardStats

func on_play(position: int) -> void:
	Constants.modify_board_stats.emit('H', 3, Constants.BoardTarget.ADJACENT, position)
