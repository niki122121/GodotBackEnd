extends Button

@export var audio:AudioStreamPlayer2D
@export var scene:String
@export var changeScene:bool

func _on_pressed() -> void:
	
	if changeScene:
		audio.reparent(get_tree().root)
		audio.finished.connect(audio.queue_free)
		audio.play()
		get_tree().change_scene_to_file("res://scenes/ui/"+scene+".tscn")
	else:
		audio.play()
