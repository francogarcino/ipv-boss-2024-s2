extends Node2D
class_name DefenseAngel

@export var angel_shock_wave_scene: PackedScene
@onready var attack_timer: Timer = $AttackTimer
@onready var angel_attack_sound: AudioStreamPlayer2D = $AngelAttackSound

var attacking: bool = false
var container: Node2D

func _ready() -> void:
	hide()

func _physics_process(delta: float) -> void:
	if (visible && !attacking):
		attacking = true
		var angel_shock_wave_instance = angel_shock_wave_scene.instantiate()
		container.add_child(angel_shock_wave_instance)
		angel_shock_wave_instance.initialize(container, global_position)
		attack_timer.start()

func set_container(container: Node2D) -> void:
	self.container = container

#func attack() -> void:
#	var angel_shock_wave_instance = angel_shock_wave_scene.instantiate()
#	get_parent().add_child(angel_shock_wave_instance)
#	angel_shock_wave_instance.initialize(global_position)
	#for demon in demons_in_area:
	#	demon.hit(1)
	#	var direction = (demon.global_position - global_position).normalized()
	#	demon.push_velocity = direction * 40.0

func _on_attack_timer_timeout() -> void:
	attack_timer.stop()
	attacking = false
