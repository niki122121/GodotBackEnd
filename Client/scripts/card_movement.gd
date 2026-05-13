class_name CardMovement

extends Control


var clickable = true

var _is_held = false
var _over_battlefield = false
var _original_position: Vector2
var _mouse_offset: Vector2
var play_left_side = false


func card_clicked() -> void:
	_is_held = true
	_original_position = global_position
	_mouse_offset = get_global_mouse_position() - global_position
	Constants.toggle_panels.emit(true)


func card_released() -> void:
	_is_held = false
	Constants.toggle_panels.emit(false)
	Constants.card_released.emit(self, _original_position, _over_battlefield, play_left_side)


func _on_gui_input(event: InputEvent) -> void:
	if clickable:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT:
				if not _is_held and event.pressed:
					card_clicked()
				elif _is_held and not event.pressed:
					card_released()
					
		if event is InputEventMouseMotion and _is_held:
			global_position = get_global_mouse_position() - _mouse_offset


func _on_area_entered(area: Area2D) -> void:
	_over_battlefield = true
	if area.get_name() == "BattlefieldLeft":
		play_left_side = true
	if area.get_name() == "BattlefieldRight":
		play_left_side = false


func _on_area_exited(_area: Area2D) -> void:
	_over_battlefield = false


func _on_mouse_entered() -> void:
	if not clickable:
		z_index = 1
		var tween = create_tween()
		tween.tween_property(self, "scale", Vector2(2.0, 2.0), Constants.TIME_HOVER_CARD_ZOOM_ANIM)


func _on_mouse_exited() -> void:
	if not clickable:
		z_index = 0
		var tween = create_tween()
		tween.tween_property(self, "scale", Vector2(1.0, 1.0), Constants.TIME_HOVER_CARD_ZOOM_ANIM)
