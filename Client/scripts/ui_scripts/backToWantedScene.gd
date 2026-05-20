extends Button

@export var scene:String

func _on_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/"+scene+".tscn")
