extends Node

@export var enemy_scene: PackedScene

func _ready():
	new_game()

func new_game():
	$EnemyTimer.start()

func _on_enemy_timer_timeout() -> void:
	var enemy = enemy_scene.instantiate()
	var enemy_spaawn_location = $EnemyPath/EnemySpawnLocation
	enemy_spaawn_location.progress_ratio = randf()
	var direction = enemy_spaawn_location.rotation + PI / 2
	enemy.position = enemy_spaawn_location.position
	direction += randf_range(-PI / 4, PI / 4)
	enemy.rotation = direction
	var velocity = Vector2(100.0, 0.0)
	enemy.linear_velocity = velocity.rotated(direction)
	add_child(enemy)
