extends CharacterBody2D
class_name Demon

const speed = 50.0
var target: Node2D
var offset: Vector2 = Vector2.ZERO
var separation_force: float = 50

func _ready() -> void:
	add_to_group("demons")
	offset = Vector2(randi_range(-50, 50), randi_range(-50, 50))

func _process(delta: float) -> void:
	if target:
		var velocity = Vector2.ZERO
		var target_position = target.global_position + offset
		velocity = (target_position - global_position).normalized() * speed

		var separation = calculate_separation()
		if separation.length() > 0:
			velocity += separation.normalized() * speed * 0.5
		
		position += velocity * delta

func calculate_separation() -> Vector2:
	var separation = Vector2.ZERO
	for demon in get_tree().get_nodes_in_group("demons"):
		if demon != self:
			var distance = global_position.distance_to(demon.global_position)
			if distance < separation_force:
				separation -= (demon.global_position - global_position).normalized() / distance
	return separation

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body is Player:
		print('Player detected!')
		get_parent()._stop_game()
