extends Node2D

class_name Projectile

signal delete_requested(projectile)

@onready var lifetime_timer: Timer = $LifetimeTimer
@onready var projectile_animations: AnimationPlayer = $ProjectileAnimations
@export var VELOCITY: float = 500.0

var direction: Vector2


func initialize(container: Node, spawn_position: Vector2, direction: Vector2) -> void:
	container.add_child(self)
	self.direction = direction
	global_position = spawn_position
	rotation = direction.angle()
	lifetime_timer.start()


func _physics_process(delta: float) -> void:
	position += direction * VELOCITY * delta


func _on_lifetime_timer_timeout() -> void:
	emit_signal("delete_requested", self)
