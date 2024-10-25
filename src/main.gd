extends Node

@export var enemy_scene: PackedScene
@export var min_distance: float = 100.0
@export var max_distance: float = 250.0
@onready var player_ref: Node2D = $Environment/Entities/Player
@onready var mejoras_menu: Control = $MejorasLayer/MejorasMenu

func _ready() -> void:
	player_ref.subir_nivel.connect(_on_mejora_conseguida)
	mejoras_menu.mejora_angel.connect(_on_angel_mejorado)
	mejoras_menu.mejora_medium.connect(_on_medium_mejorado)

func _input(event: InputEvent) -> void:
	if event.is_action("reset"):
		_reset()

func _reset() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_enemy_timer_timeout() -> void:
	_spawn_enemies()

func _spawn_enemies() -> void:
	if (player_ref != null):
		for i in range(0, 4):
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

func _stop_game() -> void:
	get_tree().paused = true
	player_ref.hide()
	await get_tree().create_timer(3).timeout
	_reset()

func _on_mejora_conseguida() -> void:
	mejoras_menu._show()

func _on_angel_mejorado() -> void:
	player_ref._on_angel_mejorado()

func _on_medium_mejorado() -> void:
	player_ref._obtener_mejora()
