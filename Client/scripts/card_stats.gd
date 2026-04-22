class_name CardStats

extends Node


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


func on_play(position: int) -> void:
	pass

func change_health(ammount) -> void:
	health += ammount
	health = clamp(health, 0, 99)
	health_label.text = str(health)
	if health == 0:
		get_parent().queue_free()


func change_attack(ammount) -> void:
	attack += ammount
	attack = clamp(attack, 0, 99)
	attack_label.text = str(attack)


func change_stat(ammount, stat) -> void:
	match stat.to_upper()[0]:
		'H':
			change_health(ammount)
		'A':
			change_attack(ammount)
		_:
			push_error("Stat is not valid (Must be Attack or Health)")


#To change stats without clamping or changing label (mostly for changing deck stats)
func change_stat_raw(ammount, stat) -> void:
	match stat.to_upper()[0]:
		'H':
			health += ammount
		'A':
			attack += ammount
		_:
			push_error("Stat is not valid (Must be Attack or Health)")


func update_labels() -> void:
	health = clamp(health, 0, 99)
	health_label.text = str(health)
	attack = clamp(attack, 0, 99)
	attack_label.text = str(attack)


func get_stat(stat) -> int:
	match stat.to_upper()[0]:
		'H':
			return health
		'A':
			return attack
		_:
			push_error("Stat is not valid (Must be Attack or Health)")
			return -1
