extends CharacterBody2D

signal finalizar_ataque()

@onready var attack_timer: Timer = $AttackTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var speed: float
var direction: Vector2

func initialize(container: Node, spawn_position: Vector2, direction: Vector2, speed: float) -> void:
	container.add_child(self)
	self.direction = direction
	self.speed = speed
	global_position = spawn_position
	rotation = direction.angle()
	attack_timer.start()

func _physics_process(delta: float) -> void:
	velocity += direction * speed * delta
	move_and_slide()

func _on_attack_timer_timeout() -> void:
	queue_free()
	emit_signal("finalizar_ataque")

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body is Demon:
		print("Attacked o:) ")
		body.hit(1.0)
		_on_attack_timer_timeout()
