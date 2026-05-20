extends Button

@export var audio:AudioStreamPlayer2D

func _on_pressed() -> void:
	audio.reparent(get_tree().root)
	audio.finished.connect(audio.queue_free)
	audio.play()
