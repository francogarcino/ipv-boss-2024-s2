extends Node2D
class_name DefenseAngel

signal demonio_eliminado(demon_position)

@onready var attack_timer: Timer = $AttackTimer
@onready var angel_attack_sound: AudioStreamPlayer2D = $AngelAttackSound

func _ready() -> void:
	hide()
