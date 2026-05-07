extends HSlider

@export var busName: String
var bus_index: int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bus_index = AudioServer.get_bus_index(busName)
	value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))
	value_changed.connect(_on_value_changed)


func _on_value_changed(newValue: float) -> void:
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(newValue))
