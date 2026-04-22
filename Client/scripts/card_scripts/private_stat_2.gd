extends CardStats

func on_play(position: int) -> void:
	Constants.search_private_card.emit('A', 3, Constants.BoardTarget.SELF, position, "Normal 3",
			Constants.PrivateTarget.HAND)
