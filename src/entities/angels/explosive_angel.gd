extends Node2D
class_name ExplosiveAngel

@export var speed: float = 200.0
@export var angel_projectile_scene: PackedScene
@onready var body: Sprite2D = $Body
@onready var angel_attack_sound: AudioStreamPlayer2D = $AngelAttackSound

var attacking: bool = false
var container: Node2D

func _ready() -> void:
	hide()

func attackAt(position: Vector2) -> void:
	if(!attacking):
		attacking = true
		var angel_projectile_instance = angel_projectile_scene.instantiate()
		container.add_child(angel_projectile_instance)
		angel_projectile_instance.initialize(container, global_position, global_position.direction_to(position), speed)
		angel_projectile_instance.finalizar_ataque.connect(_end_attack)
		hide()
		angel_attack_sound.play()

func set_container(container: Node2D) -> void:
	self.container = container

func _end_attack() -> void:
	show()
	attacking = false

func _obtener_mejora() -> void:
	speed += 100
	print("Angel speed increased!")

func _set_speed(actual_speed: float) -> void:
	speed = actual_speed
