extends CharacterBody2D

signal finalizar_ataque()

@export var angel_explosive_bomb_scene: PackedScene
@onready var attack_timer: Timer = $AttackTimer
@onready var angel_animations: AnimationPlayer = $AngelAnimations
@onready var body: Sprite2D = $Body

var speed: float
var direction: Vector2
var container: Node2D

func initialize(container: Node, spawn_position: Vector2, direction: Vector2, speed: float) -> void:
	self.container = container
	container.add_child(self)
	self.direction = direction
	self.speed = speed
	global_position = spawn_position
	rotation = direction.angle()
	attack_timer.start()

func _physics_process(delta: float) -> void:
	_play_animation("attack")
	velocity = direction * speed
	move_and_slide()

func _on_attack_timer_timeout() -> void:
	queue_free()
	emit_signal("finalizar_ataque")

func _play_animation(animation: String) -> void:
	if angel_animations.has_animation(animation):
		angel_animations.play(animation)

func _on_hitbox_area_entered(area: Area2D) -> void:
	var body = area.get_parent()
	if body is Demon:
		body.hit(2)
		var angel_explosive_bomb_instance = angel_explosive_bomb_scene.instantiate()
		container.add_child(angel_explosive_bomb_instance)
		angel_explosive_bomb_instance.initialize(container, global_position)
		#angel_attack_sound.play()
		_on_attack_timer_timeout()
