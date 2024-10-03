extends Node

@export var enemy_scene: PackedScene
@export var min_distance: float = 70.0
@export var max_distance: float = 200.0
@export var enemies_to_spawn: int = 3
@onready var player_ref: Node2D = $Environment/Entities/Player


func _on_enemy_timer_timeout() -> void:
	_spawn_enemies(enemies_to_spawn)


func _spawn_enemies(amount: int) -> void:
	for i in range(0, amount):
		var enemy = enemy_scene.instantiate()
		enemy.target = player_ref
		var distance_to_player = Vector2(
			randf_range(min_distance, max_distance), 
			randf_range(min_distance, max_distance)
		)
		enemy.position = player_ref.position + (distance_to_player * _get_relative_direction())
		add_child(enemy)


func _get_relative_direction() -> Vector2:
	var relative_x 
	if (randi() % 2 == 0):
		relative_x = 1
	else:
		relative_x = -1

	var relative_y
	if (randi() % 2 == 0):
		relative_y = 1
	else:
		relative_y = -1
	
	return Vector2(relative_x, relative_y)


func _on_debug_timer_timeout() -> void:
	# delete the enemies to clear the map - ONLY DEBUG
	var enemies = get_tree().get_nodes_in_group("demons")
	for entity in enemies:
		entity.queue_free()
