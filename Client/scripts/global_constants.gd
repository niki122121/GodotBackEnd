extends Node


signal toggle_panels(activate: bool)
signal card_released(card: CardMovement, hand_position: Vector2, on_battlefield: bool, on_left: bool)

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
const MAX_CARDS_PER_TURN = 2
const BURN_DAMAGE = 3

const OFFSET_CARD_HIT = 50 #In pixels

const TIME_ATTACK_WINDUP_ANIM = 0.5
const TIME_ATTACK_HIT_ANIM = 0.8
const TIME_ATTACK_RETURN_ANIM = 1.0
const TIME_FAILED_SUMMON_ANIM = 1.0
const TIME_HOVER_CARD_ZOOM_ANIM = 0.5
