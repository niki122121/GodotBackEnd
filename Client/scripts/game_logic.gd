extends Node


@onready var _player_hand = $"../CanvasLayer/PlayerHand"
@onready var _player_board = $"../CanvasLayer/PlayerBoard"
@onready var _enemy_hand = $"../CanvasLayer/EnemyHand"
@onready var _enemy_board = $"../CanvasLayer/EnemyBoard"

@onready var _player_health_label = $"../CanvasLayer/PlayerHealthLabel"
@onready var _enemy_health_label = $"../CanvasLayer/EnemyHealthLabel"
@onready var _turn_label = $"../CanvasLayer/TurnLabel"

@onready var battlefield_panel_left = $"../Battlefield/BattlefieldLeft/CollisionShape2D/PanelLeft"
@onready var battlefield_panel_right = $"../Battlefield/BattlefieldRight/CollisionShape2D/PanelRight"


var _is_player_turn = true
var _cards_on_hand = 0
var _player_health = Constants.INITIAL_HEALTH
var _enemy_health = Constants.INITIAL_HEALTH
var _player_deck: Array
var _enemy_deck: Array

func _ready() -> void:
	#Connect signals
	Constants.modify_board_stats.connect(_on_modify_board_stats)
	Constants.search_private_card.connect(_on_search_private_card)
	Constants.modify_private_stats.connect(_on_modify_private_stats)
	Constants.modify_board_from_private_stats.connect(_on_modify_board_from_private_stats)
	Constants.toggle_panels.connect(_on_toggle_panels)
	
	#Prepare cards and UI
	var cards: Array[PackedScene]
	for path in list_scenes("res://cards/"):
		cards.append(load(path))
	update_turn_label()
	_player_health_label.text = str(_player_health)
	_enemy_health_label.text = str(_enemy_health)
	
	#Create the players decks with an equal number of cards
	for i in range(Constants.DECK_SIZE):
		_player_deck.append(cards[i % cards.size()].instantiate())
		_enemy_deck.append(cards[i % cards.size()].instantiate())
	_player_deck.shuffle()
	_enemy_deck.shuffle()


func list_scenes(path):
	var scenes = []	

	var list = ResourceLoader.list_directory(path)
	for resource in list:
		if resource.get_extension() == "tscn":
			scenes.append(str(path, resource))
		
	return scenes


func update_turn_label() -> void:
	if _is_player_turn:
		_turn_label.text = "Your turn"
	else:
		_turn_label.text = "Enemy's turn"


func card_battle(attacker: CardStats, defender: CardStats) -> void:
	attacker.get_parent().z_index = 1
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(attacker.get_parent(), "global_position", 
			defender.get_parent().global_position, Constants.TIME_ATTACK_ANIM)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(attacker.get_parent(), "global_position", 
			attacker.get_parent().global_position, Constants.TIME_ATTACK_ANIM)
	await tween.step_finished
	defender.change_health(-attacker.attack)
	attacker.change_health(-defender.attack)
	print(attacker.title, " attacked ", defender.title, ", leaving them with ", attacker.health,
			 " and ", defender.health, " health each")
	if defender.health <= 0:
		print(defender.title, " was killed in combat!")
		defender.get_parent().queue_free()
	if attacker.health <= 0:
		print(attacker.title, " died in combat!")
		attacker.get_parent().queue_free()
	await tween.finished
	if attacker:
		attacker.get_parent().z_index = 0


func face_battle(attacker: CardStats) -> void:
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_EXPO)
	if _is_player_turn:
		#TODO: Change target when we have a PlayerFace node
		tween.tween_property(attacker.get_parent(), "global_position", Vector2(540, 75), 
				Constants.TIME_ATTACK_ANIM)
		tween.set_trans(Tween.TRANS_SINE)
		tween.tween_property(attacker.get_parent(), "global_position", 
				attacker.get_parent().global_position, Constants.TIME_ATTACK_ANIM)
		await tween.step_finished
		_enemy_health -= attacker.attack
		_enemy_health_label.text = str(_enemy_health)
		print(attacker.title, " has hit the opponent, leaving them with ", _enemy_health, " health!")
		if _enemy_health <= 0:
			print("Game over! The player wins!")
	else:
		#TODO: Change target when we have a PlayerFace node
		tween.tween_property(attacker.get_parent(), "global_position", Vector2(540, 645), 
				Constants.TIME_ATTACK_ANIM)
		tween.set_trans(Tween.TRANS_SINE)
		tween.tween_property(attacker.get_parent(), "global_position", 
				attacker.get_parent().global_position, Constants.TIME_ATTACK_ANIM)
		await tween.step_finished
		_player_health -= attacker.attack
		_player_health_label.text = str(_player_health)
		print(attacker.title, " has hit you, leaving you with ", _player_health, " health!")
		if _player_health <= 0:
			print("Game over! The enemy wins!")
	await tween.finished


func get_board_cards(current_player: bool) -> Array[Node]:
	var cards
	if (_is_player_turn and current_player) or (!_is_player_turn and !current_player):
		cards = _player_board.get_children()
	else:
		cards = _enemy_board.get_children()
	
	return cards


func _on_toggle_panels(activate: bool) -> void:
	battlefield_panel_left.visible = activate
	battlefield_panel_right.visible = activate


func _on_player_draw_button_pressed() -> void:
	_cards_on_hand = _player_hand.get_child_count()
	if _player_deck.size() > 0:
		if _cards_on_hand < Constants.MAX_HAND:
			var new_card = _player_deck.pop_back()
			_player_hand.add_child(new_card)
			new_card.find_child("CardStats").update_labels()
	else:
		print("Your deck is empty! You take ", Constants.BURN_DAMAGE , " burn damage")
		_player_health -= Constants.BURN_DAMAGE
		_player_health_label.text = str(_player_health)


func _on_enemy_draw_button_pressed() -> void:
	pass


func _on_enemy_play_button_pressed() -> void:
	if _is_player_turn:
		return
	
	if _enemy_deck.size() > 0:
		if _enemy_board.get_child_count() < Constants.MAX_BOARD:
			var new_card = _enemy_deck.pop_back()
			new_card._clickable = false
			_enemy_board.add_child(new_card)
			new_card.find_child("CardStats").on_play(1)
	else:
		print("The enemy deck is empty! They take ", Constants.BURN_DAMAGE , " burn damage")
		_enemy_health -= Constants.BURN_DAMAGE
		_enemy_health_label.text = str(_enemy_health)


func _on_end_turn_button_pressed() -> void:
	print("Beggining combat phase...")
	
	var attacker_cards = get_board_cards(true)
	for i in attacker_cards.size():
			var attacker = attacker_cards[i].find_child("CardStats")
			var defender_cards = get_board_cards(false)
			print(attacker.title, " has been activated")
			if defender_cards.size() > 0:
				var defender
				var card_position = attacker.get_parent().position
				#Attack closest card, prioritizing the left on a tie
				for j in defender_cards.size():
					if defender_cards[j].position <= card_position:
						defender = defender_cards[j].find_child("CardStats")
				if defender == null:
					defender = defender_cards[0].find_child("CardStats")
				await card_battle(attacker, defender)
			else:
				await face_battle(attacker)
	
	_is_player_turn = not _is_player_turn
	update_turn_label()
	print("\n")


func _on_modify_board_stats(stat: String, ammount: int, target: Constants.BoardTarget, origin: int) -> void:
	var affected_cards = get_board_cards(true)
	match target:
		Constants.BoardTarget.SELF:
			if origin == 0:
				affected_cards[0].find_child("CardStats").change_stat(ammount, stat)
			else:
				affected_cards[-1].find_child("CardStats").change_stat(ammount, stat)
		Constants.BoardTarget.ADJACENT:
			if affected_cards.size() > 1:
				if origin == 0:
					affected_cards[1].find_child("CardStats").change_stat(ammount, stat)
				else:
					affected_cards[-2].find_child("CardStats").change_stat(ammount, stat)
		Constants.BoardTarget.OWNER:
			for card in affected_cards:
				card.find_child("CardStats").change_stat(ammount, stat)
		Constants.BoardTarget.OWNER_LEFT:
			for card in affected_cards.slice(0, affected_cards.size()/2):
				card.find_child("CardStats").change_stat(ammount, stat)
		Constants.BoardTarget.OWNER_RIGHT:
			for card in affected_cards.slice(-affected_cards.size()/2):
				card.find_child("CardStats").change_stat(ammount, stat)
		Constants.BoardTarget.OPPONENT:
			affected_cards = get_board_cards(false)
			for card in affected_cards:
				card.find_child("CardStats").change_stat(ammount, stat)
		Constants.BoardTarget.ALL:
			affected_cards = get_board_cards(true) + get_board_cards(false)
			for card in affected_cards:
				card.find_child("CardStats").change_stat(ammount, stat)


func _on_search_private_card(stat: String, ammount: int, target: Constants.BoardTarget, origin: int, 
		card_title: String, search_target: Constants.PrivateTarget, depth: int = 0) -> void:
	#TODO: Remove when online is added
	if _is_player_turn == false:
		return
	
	var card_found = false
	if search_target == Constants.PrivateTarget.HAND:
		for card in _player_hand.get_children():
			if card.find_child("CardStats").title == card_title:
				card_found = true
				break
	elif search_target == Constants.PrivateTarget.DECK:
		for card in _player_deck.slice(-depth):
			if card.find_child("CardStats").title == card_title:
				card_found = true
				break
	
	if card_found:
		if target == Constants.BoardTarget.SELF:
				if origin == 0:
					get_board_cards(true)[0].find_child("CardStats").change_stat(ammount, stat)
				else:
					get_board_cards(true)[-1].find_child("CardStats").change_stat(ammount, stat)


func _on_modify_private_stats(stat: String, ammount: int, target: Constants.PrivateTarget, 
		depth: int = 0) -> void:
	#TODO: Remove when online is added
	if _is_player_turn == false:
		return
	
	if target == Constants.PrivateTarget.HAND:
		for card in _player_hand.get_children():
			card.find_child("CardStats").change_stat(ammount, stat)
	elif target == Constants.PrivateTarget.DECK:
		for card in _player_deck.slice(-depth):
			card.find_child("CardStats").change_stat_raw(ammount, stat)



func _on_modify_board_from_private_stats(stat: String, ammount: int, target: Constants.BoardTarget, 
		origin: int, search_target: Constants.PrivateTarget, search_stat: String, 
		search_ammount: int, depth: int = 0) -> void:
	#TODO: Remove when online is added
	if _is_player_turn == false:
		return
	
	var found_ammount = 0
	if search_target == Constants.PrivateTarget.HAND:
		for card in _player_hand.get_children():
			found_ammount += card.find_child("CardStats").get_stat(search_stat)
	elif search_target == Constants.PrivateTarget.DECK:
		for card in _player_deck.slice(-depth):
			found_ammount += card.find_child("CardStats").get_stat(search_stat)
	
	if found_ammount >= search_ammount:
		if target == Constants.BoardTarget.SELF:
				if origin == 0:
					get_board_cards(true)[0].find_child("CardStats").change_stat(ammount, stat)
				else:
					get_board_cards(true)[-1].find_child("CardStats").change_stat(ammount, stat)
