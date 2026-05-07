class_name Parallax

extends Control

var window: Vector2
var centerX: int
var centerY: int 

@export var globalParallaxAdjust: float = 0.5
@export var parallaxOffsets: Array[float] = [] 


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	window  = get_viewport().size
	centerX = window.x / 2
	centerY = window.y / 2
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var offsetX: float = clamp((get_global_mouse_position().x - centerX) / centerX, -1, 1)
	var offsetY: float = clamp((get_global_mouse_position().y - centerY) / centerY, -1, 1)
	
	var count: int = 0
	for image in get_children():
		if image is Sprite2D:
			image.position = Vector2(offsetX * parallaxOffsets[count] * globalParallaxAdjust, offsetY * parallaxOffsets[count] * globalParallaxAdjust)
			count += 1

#func returnPos():
	#var tween
	#for image in get_children():
		#if image is Sprite2D:
			#tween = create_tween()
			#tween.tween_property(image, "position", Vector2(0, 0), 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	#
	#await tween.finished
	#self.set_script(null)
