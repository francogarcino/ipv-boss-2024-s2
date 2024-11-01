extends Node2D
class_name Angel

signal subir_nivel()
signal invocar_santuario()

@onready var attack_timer: Timer = $AttackTimer
@export var speed: float = 200.0
@export var angel_projectile_scene: PackedScene
@onready var demon_death_sound: AudioStreamPlayer2D = $DemonDeathSound
@onready var angel_attack_sound: AudioStreamPlayer2D = $AngelAttackSound

var attacking: bool = false 
var container: Node2D
var defeated_enemies = 0
var actual_level = 0

func _ready() -> void:
	demon_death_sound.process_mode = Node.PROCESS_MODE_ALWAYS
	angel_attack_sound.process_mode = Node.PROCESS_MODE_ALWAYS

func attackAt(position: Vector2) -> void:
	if(!attacking):
		attacking = true
		var angel_projectile_instance = angel_projectile_scene.instantiate()
		container.add_child(angel_projectile_instance)
		angel_projectile_instance.initialize(container, global_position, global_position.direction_to(position), speed)
		angel_projectile_instance.angel = self
		hide()
		angel_attack_sound.play()

func set_container(container: Node2D) -> void:
	self.container = container

func _end_attack() -> void:
	show()
	attacking = false

func _demon_deleted() -> void:
	demon_death_sound.play()
	defeated_enemies += 1
	if defeated_enemies == ((actual_level + 1) * 20):
		actual_level += 1
		if actual_level % 3 == 0:
			emit_signal("invocar_santuario")
		print("level_up: ", actual_level)
		emit_signal("subir_nivel")

func _obtener_mejora() -> void:
	speed += speed * 0.5
	print("Angel speed increased!")
