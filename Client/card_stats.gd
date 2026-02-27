extends Node

class_name CardStats


@export var health: int = 0
@export var attack: int = 0
@export var title: String = "Generic"

@onready var health_label: Label = $"../Health"
@onready var attack_label: Label = $"../Attack"
@onready var title_label: Label = $"../Title"


func _ready() -> void:
	health_label.text = str(health)
	attack_label.text = str(attack)
	title_label.text = title
	


func change_health(amount) -> void:
	health += amount
	health = clamp(health, 0, 99)
	health_label.text = str(health)
