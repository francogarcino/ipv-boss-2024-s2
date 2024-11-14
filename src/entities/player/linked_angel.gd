extends Node2D
class_name Angel

signal demonio_eliminado(demon_position)

@onready var attack_timer: Timer = $AttackTimer
@export var speed: float = 200.0
@export var angel_projectile_scene: PackedScene
@onready var demon_death_sound: AudioStreamPlayer2D = $DemonDeathSound
@onready var angel_attack_sound: AudioStreamPlayer2D = $AngelAttackSound

var attacking: bool = false 
var container: Node2D

func attackAt(position: Vector2) -> void:
	if(!attacking):
		attacking = true
		var angel_projectile_instance = angel_projectile_scene.instantiate()
		container.add_child(angel_projectile_instance)
		angel_projectile_instance.initialize(container, global_position, global_position.direction_to(position), speed)
		angel_projectile_instance.demonio_eliminado.connect(_demon_deleted)
		angel_projectile_instance.finalizar_ataque.connect(_end_attack)
		hide()
		angel_attack_sound.play()

func set_container(container: Node2D) -> void:
	self.container = container

func _end_attack() -> void:
	show()
	attacking = false

func _demon_deleted(demon_position: Vector2) -> void:
	demon_death_sound.play()
	emit_signal("demonio_eliminado", demon_position)

func _obtener_mejora() -> void:
	speed += speed * 0.5
	print("Angel speed increased!")
