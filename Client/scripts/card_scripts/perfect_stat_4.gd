extends CardStats

func on_play(position: int) -> void:
	Constants.modify_board_stats.emit('A', -1, Constants.BoardTarget.OPPONENT, position)
