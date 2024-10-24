extends Node2D
class_name Angel

@onready var attack_timer: Timer = $AttackTimer
@export var speed: float = 400.0
@export var angel_projectile_scene: PackedScene

var attacking: bool = false 
var container: Node2D
var defeated_enemies = 0

func attackAt(position: Vector2) -> void:
	if(!attacking):
		attacking = true
		var angel_projectile_instance = angel_projectile_scene.instantiate()
		container.add_child(angel_projectile_instance)
		angel_projectile_instance.initialize(container, global_position, global_position.direction_to(position), speed)
		angel_projectile_instance.angel = self
		hide()

func set_container(container: Node2D) -> void:
	self.container = container

func _end_attack() -> void:
	show()
	attacking = false

func _demon_deleted() -> void:
	defeated_enemies += 1
	if defeated_enemies == 10:
		speed += speed * 0.5
		print("Angel speed increased!")
