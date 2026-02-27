extends Control


var _clickable = true
var _is_held = false
var _over_battlefield = false
var _original_position: Vector2
var _mouse_offset: Vector2
var _play_left_side = false


func _on_gui_input(event: InputEvent) -> void:
	if _clickable:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT:
				if not _is_held and event.pressed:
					card_clicked()
				elif _is_held and not event.pressed:
					card_released()
					
		if event is InputEventMouseMotion and _is_held:
			global_position = get_global_mouse_position() - _mouse_offset


func card_clicked() -> void:
	_is_held = true
	_original_position = global_position
	_mouse_offset = get_global_mouse_position() - global_position
	#print("pressed")


func card_released() -> void:
	_is_held = false
	if _over_battlefield:
		#print("battle")
		reparent($"../../PlayerBoard")
		if _play_left_side:
			get_parent().move_child(self, 0)
		_clickable = false
	else:
		global_position = _original_position
	#print("released")


func _on_area_entered(area: Area2D) -> void:
	_over_battlefield = true
	if area.get_name() == "BattlefieldLeft":
		_play_left_side = true
	if area.get_name() == "BattlefieldRight":
		_play_left_side = false


func _on_area_exited(_area: Area2D) -> void:
	_over_battlefield = false
