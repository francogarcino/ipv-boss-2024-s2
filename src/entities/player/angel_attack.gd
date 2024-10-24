extends Node2D

@onready var attack_timer: Timer = $AttackTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var speed: float
var angel: Node2D
var direction: Vector2

func initialize(container: Node, spawn_position: Vector2, direction: Vector2, speed: float) -> void:
	container.add_child(self)
	self.direction = direction
	self.speed = speed
	global_position = spawn_position
	rotation = direction.angle()
	attack_timer.start()

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _on_attack_timer_timeout() -> void:
	queue_free()
	angel._end_attack()

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body is Demon:
		print("Attacked o:) ")
		body.queue_free()
		angel._demon_deleted()
		_on_attack_timer_timeout()
