extends Node

@export var enemy_scene: PackedScene
@export var sanctuary_scene: PackedScene
@export var experience_scene: PackedScene
@export var defender_angel_scene: PackedScene
@export var x_size: float 
@export var y_size: float 
@onready var player_ref: Node2D = $Environment/Entities/Player
@onready var gui: Control = $UILayer/GUI
@onready var main_menu: Control = $UILayer/MainMenu
@onready var improvement_menu: Control = $UILayer/ImprovementMenu
@onready var defeat_menu: Control = $UILayer/DefeatMenu
@onready var pause_menu: Control = $UILayer/PauseMenu
@onready var sanctuary_menu: Control = $UILayer/SanctuaryMenu
@onready var level_up_sound: AudioStreamPlayer2D = $LevelUpSound
@onready var resurrection_effect: ColorRect = $Environment/Entities/Player/ResurrectionEffect
@onready var resurrection_timer: Timer = $Environment/Entities/Player/ResurrectionEffect/ResurrectionTimer
@onready var resurrection_sound: AudioStreamPlayer2D = $ResurrectionSound
@onready var demon_death_sound: AudioStreamPlayer2D = $DemonDeathSound

var actual_level = 0

func _ready() -> void:
	x_size = float(get_viewport().size.x / 3)
	y_size = float(get_viewport().size.y * 0.5)
	
	player_ref.subir_nivel.connect(_on_mejora_conseguida)
	player_ref.invocar_santuario.connect(_spawn_santuario)
	main_menu.start.connect(_start)
	improvement_menu.mejora_angel.connect(_on_angel_mejorado)
	improvement_menu.mejora_medium.connect(_on_medium_mejorado)
	defeat_menu.retry.connect(_reset)
	pause_menu.retry.connect(_reset)

func _start() -> void:
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
				var distance_to_player = Vector2(x_size + randi_range(0, 320), y_size + randi_range(0, 80))
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

func _player_defeated() -> void:
	pause_menu.is_accepted = false
	defeat_menu._show()

func _destroy_sanctuary() -> void:
	pause_menu.is_accepted = false
	var sanctuary = get_tree().get_nodes_in_group("sanctuaries").pop_at(0)
	resurrection_effect.show()
	resurrection_sound.play()
	resurrection_timer.start()
	get_tree().paused = true
	sanctuary._remove()
	gui._lose_life()

func _on_mejora_conseguida() -> void:
	actual_level += 1
	pause_menu.is_accepted = false
	level_up_sound.play()
	improvement_menu._show()
	gui._add_lvl()

func _on_angel_mejorado() -> void:
	pause_menu.is_accepted = true
	player_ref._on_angel_mejorado()

func _on_medium_mejorado() -> void:
	pause_menu.is_accepted = true
	player_ref._obtener_mejora()
	
func _spawn_santuario() -> void:
	actual_level += 1
	var sanctuary = sanctuary_scene.instantiate()
	sanctuary.position = player_ref.position
	sanctuary.z_index = -1
	gui._add_life()
	add_child(sanctuary)
	gui._add_lvl()
	if actual_level == 3:
		spawn_angel_defender()
	sanctuary_menu._show()

func spawn_angel_defender() -> void:
	var defender_angel = defender_angel_scene.instantiate()
	var distance_to_player = Vector2(x_size + randi_range(0, 320), y_size + randi_range(0, 80))
	defender_angel.position = player_ref.position + (distance_to_player * _get_relative_direction())
	defender_angel.z_index = -1
	add_child(defender_angel)

func _spawn_experience(demon_position: Vector2) -> void:
	demon_death_sound.play()
	var experience = experience_scene.instantiate()
	experience.position = demon_position
	experience.z_index = -1
	add_child(experience)

func _on_resurrection_timer_timeout() -> void:
	resurrection_timer.stop()
	resurrection_effect.hide()
	get_tree().paused = false
	pause_menu.is_accepted = true
