extends CharacterBody2D

signal finalizar_ataque()

@onready var attack_timer: Timer = $AttackTimer
@onready var angel_animations: AnimationPlayer = $AngelAnimations

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
	_play_animation("attack")
	velocity += direction * speed * delta
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
		print("Attacked o:) ")
		body.hit(2)
		_on_attack_timer_timeout()
