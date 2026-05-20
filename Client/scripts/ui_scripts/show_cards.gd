extends Control

@export var sizeMultiplier:float

#New textures for the sprites
@export var firstImage: Texture2D
@export var rightImage: Texture2D
@export var leftImage: Texture2D

@export var firstCard:Sprite2D
@export var rightCard:Sprite2D
@export var leftCard:Sprite2D
@export var panel:ColorRect
var rightOrigin:Vector2
var leftOrigin:Vector2
var currentTween:Tween

func _ready() -> void:
	firstCard.texture = firstImage
	rightCard.texture = rightImage
	leftCard.texture = leftImage
	
	rightOrigin = rightCard.position
	leftOrigin = leftCard.position
	

func _on_mouse_entered() -> void:
	
	z_index = 3
	panel.show()
	
	if currentTween and currentTween.is_valid():
		currentTween.kill()
	
	currentTween = create_tween()
	currentTween.tween_property(self, "scale", Vector2(sizeMultiplier, sizeMultiplier), Constants.TIME_HOVER_CARD_ZOOM_ANIM)
	currentTween.parallel().tween_property(rightCard, "position", rightOrigin + Vector2(self.size.x * 0.1 + self.size.x, 0), Constants.TIME_HOVER_CARD_ZOOM_ANIM).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	currentTween.parallel().tween_property(leftCard, "position", leftOrigin + Vector2(-self.size.x * 0.1 - self.size.x, 0), Constants.TIME_HOVER_CARD_ZOOM_ANIM).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	
	
func _on_mouse_exited() -> void:
	
	panel.hide()
	
	if currentTween and currentTween.is_valid():
		currentTween.kill()
	
	currentTween = create_tween()
	currentTween.tween_property(self, "scale", Vector2(1.0, 1.0), Constants.TIME_HOVER_CARD_ZOOM_ANIM)
	currentTween.parallel().tween_property(rightCard, "position", rightOrigin, Constants.TIME_HOVER_CARD_ZOOM_ANIM)
	currentTween.parallel().tween_property(leftCard, "position", leftOrigin, Constants.TIME_HOVER_CARD_ZOOM_ANIM)
	
	await currentTween.finished
	z_index = 1
	
