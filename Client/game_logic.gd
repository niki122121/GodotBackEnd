extends Node

const DECK_SIZE = 20
const INITIAL_HEALTH = 15
const MAX_BOARD = 8
const MAX_HAND = 7
const BURN_DAMAGE = 1

@onready var _player_hand = $"../CanvasLayer/PlayerHand"
@onready var _player_board = $"../CanvasLayer/PlayerBoard"
@onready var _enemy_hand = $"../CanvasLayer/EnemyHand"
@onready var _enemy_board = $"../CanvasLayer/EnemyBoard"

@onready var _player_health_label = $"../CanvasLayer/PlayerHealthLabel"
@onready var _enemy_health_label = $"../CanvasLayer/EnemyHealthLabel"
@onready var _turn_label = $"../CanvasLayer/TurnLabel"

var _cards = [
	preload("res://cards/test_card_1.tscn"),
	preload("res://cards/test_card_2.tscn"),
	preload("res://cards/test_card_3.tscn"),
	preload("res://cards/test_card_4.tscn"),
]

var _is_player_turn = true
var _cards_on_hand = 0
var _player_health = INITIAL_HEALTH
var _enemy_health = INITIAL_HEALTH
var _player_deck: Array
var _enemy_deck: Array


func _ready() -> void:
	update_turn_label()
	_player_health_label.text = str(_player_health)
	_enemy_health_label.text = str(_enemy_health)
	for i in range(DECK_SIZE):
		#5 of each test card for each deck
		_player_deck.append((_cards[i % 4] as PackedScene).instantiate())
		_enemy_deck.append((_cards[i % 4] as PackedScene).instantiate())
	_player_deck.shuffle()
	_enemy_deck.shuffle()


func update_turn_label() -> void:
	if _is_player_turn:
		_turn_label.text = "Your turn"
	else:
		_turn_label.text = "Enemy's turn"


func card_battle(attacker: CardStats, defender: CardStats) -> void:
	defender.change_health(-attacker.attack)
	attacker.change_health(-defender.attack)
	print(attacker.title, " attacked ", defender.title, ", leaving them with ", attacker.health, " and ", defender.health, " health each")
	
	if defender.health <= 0:
		print(defender.title, " was killed in combat!")
		defender.get_parent().free()
		
	if attacker.health <= 0:
		print(attacker.title, " died in combat!")
		attacker.get_parent().free()


func face_battle(attacker: CardStats) -> void:
	if _is_player_turn:
		_enemy_health -= attacker.attack
		_enemy_health_label.text = str(_enemy_health)
		print(attacker.title, " has hit the opponent, leaving them with ", _enemy_health, " health!")
	else:
		_player_health -= attacker.attack
		_player_health_label.text = str(_player_health)
		print(attacker.title, " has hit you, leaving you with ", _player_health, " health!")


func _on_player_draw_button_pressed() -> void:
	_cards_on_hand = _player_hand.get_child_count()
	if _player_deck.size() > 0:
		if _cards_on_hand < MAX_HAND:
			var new_card = _player_deck.pop_back()
			_player_hand.add_child(new_card)
	else:
		print("Your deck is empty! You take burn damage")
		_player_health -= BURN_DAMAGE
		_player_health_label.text = str(_player_health)


func _on_enemy_draw_button_pressed() -> void:
	pass


func _on_enemy_play_button_pressed() -> void:
	if _enemy_deck.size() > 0:
		var new_card = _enemy_deck.pop_back()
		_enemy_board.add_child(new_card)
	else:
		print("The enemy deck is empty! They take burn damage")
		_enemy_health -= BURN_DAMAGE
		_enemy_health_label.text = str(_enemy_health)


func _on_end_turn_button_pressed() -> void:
	if _is_player_turn:
		print("Beggining player combat phase...")
		var player_cards = _player_board.get_children()
		for i in player_cards.size():
			var attacker = player_cards[i].find_child("CardStats")
			var enemy_cards = _enemy_board.get_children()
			print(attacker.title, " has been activated")
			if enemy_cards.size() > 0:
				var defender
				var card_position = attacker.get_parent().position
				#Attack closest card on the left
				for j in enemy_cards.size():
					if enemy_cards[j].position <= card_position:
						defender = enemy_cards[j].find_child("CardStats")
				if defender == null:
					defender = enemy_cards[0].find_child("CardStats")
				card_battle(attacker, defender)
			else:
				face_battle(attacker)
		if _enemy_health <= 0:
			print("Game over! The player wins!")
	
	else:
		print("Beggining enemy combat phase...")
		var enemy_cards = _enemy_board.get_children()
		for i in enemy_cards.size():
			var attacker = enemy_cards[i].find_child("CardStats")
			var player_cards = _player_board.get_children()
			print(attacker.title, " has been activated")
			if player_cards.size() > 0:
				var defender
				var card_position = attacker.get_parent().position
				#Attack closest card on the left
				for j in player_cards.size():
					if player_cards[j].position <= card_position:
						defender = player_cards[j].find_child("CardStats")
				if defender == null:
					defender = player_cards[0].find_child("CardStats")
				card_battle(attacker, defender)
			else:
				face_battle(attacker)
		if _player_health <= 0:
			print("Game over! The enemy wins!")
	
	_is_player_turn = not _is_player_turn
	update_turn_label()
	print("\n")
