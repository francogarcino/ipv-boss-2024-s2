extends Node

@export var enemy_scene: PackedScene

func _ready():
	new_game()

func new_game():
	$EnemyTimer.start()

func _on_enemy_timer_timeout() -> void:
	var enemy = enemy_scene.instantiate()
	var enemy_spawn_coord = $EnemyPath/EnemySpawnLocation
	enemy_spawn_coord.progress_ratio = randf()
	var direction = enemy_spawn_coord.rotation + PI / 2
	enemy.position = enemy_spawn_coord.position
	direction += randf_range(-PI / 4, PI / 4)
	enemy.rotation = direction
	var velocity = Vector2(100.0, 0.0)
	enemy.linear_velocity = velocity.rotated(direction)
	add_child(enemy)
