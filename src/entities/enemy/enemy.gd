extends CharacterBody2D

const speed = 50.0
var target: Node2D


func _ready() -> void:
	add_to_group("demons")


func _process(delta: float) -> void:
	if (target != null):
		var velocity = Vector2.ZERO
		var pathToPlayer = target.global_position
		if pathToPlayer.x < global_position.x:
			velocity.x -= 1
		if pathToPlayer.x > global_position.x:
			velocity.x += 1
		if pathToPlayer.y < global_position.y:
			velocity.y -= 1
		if pathToPlayer.y > global_position.y:
			velocity.y += 1
		if velocity.length() > 0:
			velocity = velocity.normalized() * speed
		position += velocity * delta
