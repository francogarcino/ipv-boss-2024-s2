extends Node

@export var enemy_scene: PackedScene
@export var sanctuary_scene: PackedScene
@export var x_size: float 
@export var y_size: float 
@onready var player_ref: Node2D = $Environment/Entities/Player
@onready var mejoras_menu: Control = $UILayer/MejorasMenu
@onready var defeat_menu: Control = $UILayer/DefeatMenu
@onready var pause_menu: Control = $UILayer/PauseMenu


func _ready() -> void:
	x_size = float(get_viewport().size.x / 2) # 540
	y_size = float(get_viewport().size.y / 2) # 360
	
	player_ref.subir_nivel.connect(_on_mejora_conseguida)
	player_ref.invocar_santuario.connect(_spawn_santuario)
	mejoras_menu.mejora_angel.connect(_on_angel_mejorado)
	mejoras_menu.mejora_medium.connect(_on_medium_mejorado)
	defeat_menu.retry.connect(_reset)
	pause_menu.retry.connect(_reset)
	pause_menu.is_accepted = true

func _reset() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_enemy_timer_timeout() -> void:
	_spawn_enemies()

func _spawn_enemies() -> void:
	var enemies = get_tree().get_nodes_in_group("demons")
	if (enemies.size() < 200):
		if (player_ref != null):
			for i in range(0, 10):
				var enemy = enemy_scene.instantiate()
				enemy.target = player_ref
				var distance_to_player = Vector2(x_size + randi_range(0, 120), y_size + randi_range(0, 120))
				enemy.position = player_ref.position + (distance_to_player * _get_relative_direction())
				add_child(enemy)
	else:
		# Too many enemies :P
		pass

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

func _player_defeated() -> void:
	pause_menu.is_accepted = false
	defeat_menu._show()

func _on_mejora_conseguida() -> void:
	mejoras_menu._show()

func _on_angel_mejorado() -> void:
	player_ref._on_angel_mejorado()

func _on_medium_mejorado() -> void:
	player_ref._obtener_mejora()
	
func _spawn_santuario() -> void:
	var sanctuary = sanctuary_scene.instantiate()
	sanctuary.position = player_ref.position
	sanctuary.z_index = -1
	add_child(sanctuary)
