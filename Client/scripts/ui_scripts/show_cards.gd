extends Control

@export var sizeMultiplier:float
@export var rightCard:Sprite2D
@export var leftCard:Sprite2D
@export var panel:ColorRect
var rightOrigin:Vector2
var leftOrigin:Vector2
var showing:bool

func _ready() -> void:
	rightOrigin = rightCard.position
	leftOrigin = leftCard.position
	print(rightOrigin)
	

func _on_mouse_entered() -> void:
	
	z_index = 2
	panel.show()
	#rightCard.show()
	#leftCard.show()
	#
	#showing = true
	
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(sizeMultiplier, sizeMultiplier), Constants.TIME_HOVER_CARD_ZOOM_ANIM)
	tween.parallel().tween_property(rightCard, "position", rightOrigin + Vector2(self.size.x * 0.1 + self.size.x, 0), Constants.TIME_HOVER_CARD_ZOOM_ANIM).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(leftCard, "position", leftOrigin + Vector2(-self.size.x * 0.1 - self.size.x, 0), Constants.TIME_HOVER_CARD_ZOOM_ANIM).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	#await  tween.finished
	#showing = false
	
func _on_mouse_exited() -> void:
	z_index = 0
	panel.hide()
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), Constants.TIME_HOVER_CARD_ZOOM_ANIM)
	tween.parallel().tween_property(rightCard, "position", rightOrigin, Constants.TIME_HOVER_CARD_ZOOM_ANIM)
	tween.parallel().tween_property(leftCard, "position", leftOrigin, Constants.TIME_HOVER_CARD_ZOOM_ANIM)
	
	#await tween.finished
	#
	#if !showing:
		#rightCard.hide()
		#leftCard.hide()
