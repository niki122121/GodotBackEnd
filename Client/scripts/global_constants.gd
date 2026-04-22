extends Node


signal toggle_panels(activate: bool)

#For origin, 0 = played on left side, 1 = played on right side
signal modify_board_stats(stat: String, ammount: int, target: BoardTarget, origin: int)
signal search_private_card(stat: String, ammount: int, target: BoardTarget, origin: int, 
		card_title: String, search_target: PrivateTarget, depth: int)
signal modify_private_stats(stat: String, ammount: int, target: PrivateTarget, depth: int)
signal modify_board_from_private_stats(stat: String, ammount: int, target: BoardTarget, 
		origin: int, search_target: PrivateTarget, search_stat: String, search_ammount: int,
		depth: int)

enum BoardTarget {
	SELF,
	ADJACENT,
	OWNER,
	OWNER_LEFT,
	OWNER_RIGHT,
	OPPONENT,
	#OPPONENT_LEFT,
	#OPPONENT_RIGHT,
	ALL,
}

enum PrivateTarget{
	HAND,
	#HAND_LEFT,
	#HAND_RIGHT,
	DECK
}

const DECK_SIZE = 32
const INITIAL_HEALTH = 100#15
const MAX_BOARD = 8
const MAX_HAND = 7
const BURN_DAMAGE = 3

const TIME_ATTACK_ANIM = 1.0 #Since cards move twice in attack, multiply by 2 to get total time
const TIME_FAILED_SUMMON_ANIM = 1.0
const TIME_HOVER_CARD_ZOOM_ANIM = 0.5
