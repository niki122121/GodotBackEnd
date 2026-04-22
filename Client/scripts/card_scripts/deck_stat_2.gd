extends CardStats

func on_play(position: int) -> void:
	Constants.search_private_card.emit('A', 5, Constants.BoardTarget.SELF, position, "Normal 1",
			Constants.PrivateTarget.DECK, 5)
