extends CharacterBody2D
class_name Demon

const speed = 25.0
var target: Node2D
var offset: Vector2 = Vector2.ZERO
var separation_force: float = 50
var max_hp: int = 2
var hp: int = 2

@onready var hp_progress: ProgressBar = $HpProgress
var hp_tween: Tween

func _ready() -> void:
	add_to_group("demons")
	offset = Vector2(randi_range(-50, 50), randi_range(-50, 50))
	hp_progress.max_value = max_hp
	hp_progress.value = hp
	hp_progress.modulate = Color.TRANSPARENT

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
		if has_active_sanctuaries():
			get_parent()._destroy_sanctuary()
		else:
			print('Player detected!')
			get_parent()._player_defeated()

func has_active_sanctuaries() -> bool:
	return get_tree().get_nodes_in_group("sanctuaries").size() > 0

func hit(amount: int) -> void:
	hp = clamp(hp - amount, 0, max_hp)
	hp_progress.value = hp
	if hp <= 0:
		_remove()
	if hp_tween:
		hp_tween.kill()
	hp_tween = create_tween()
	hp_progress.modulate = Color.WHITE
	hp_tween.tween_property(hp_progress, "modulate", Color.TRANSPARENT, 5.0)

func _remove() -> void:
	get_parent()._spawn_experience(global_position)
	deleted()

func deleted() -> void:
	get_parent().remove_child(self)
	queue_free()
