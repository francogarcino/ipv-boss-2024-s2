extends Node2D

@onready var hitbox: Area2D = $Hitbox
@onready var body_collider: CollisionShape2D = $Hitbox/BodyCollider
@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D


func initialize(container: Node, spawn_position: Vector2) -> void:
	container.add_child(self)
	global_position = spawn_position

func _ready() -> void:
	cpu_particles_2d.restart()
	body_collider.shape.radius = 0.0
	var tween = create_tween()
	tween.tween_property(body_collider.shape, "radius", 70, 0.57)
	hitbox.monitoring = true
	tween.tween_callback(remove)

func remove():
	get_parent().remove_child(self)
	queue_free()

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body is Demon:
		body.hit(1)
		var direction = (body.global_position - global_position).normalized()
		body.push_velocity = direction * 40.0
