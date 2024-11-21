extends Node

@export var basic_demon_scene: PackedScene
@export var fast_demon_scene: PackedScene
@export var heavy_demon_scene: PackedScene
@export var sanctuary_scene: PackedScene
@export var experience_scene: PackedScene
@export var defender_angel_scene: PackedScene
@export var attacking_angel_scene: PackedScene
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
@onready var game_sound: AudioStreamPlayer2D = $GameSound

var actual_level = 0

func _ready() -> void:
	x_size = float(get_viewport().size.x / 3)
	y_size = float(get_viewport().size.y * 0.5)
	
	player_ref.subir_nivel.connect(_on_mejora_conseguida)
	player_ref.invocar_santuario.connect(_spawn_santuario)
	player_ref.experiencia_obtenida.connect(gui._add_exp)
	main_menu.start.connect(_start)
	improvement_menu.mejora_angel.connect(_on_angel_mejorado)
	improvement_menu.mejora_medium.connect(_on_medium_mejorado)
	defeat_menu.retry.connect(_reset)
	pause_menu.retry.connect(_reset)

func _start() -> void:
	pause_menu.is_accepted = true
	game_sound.play()

func _reset() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_enemy_timer_timeout() -> void:
	_spawn_enemies()

func _spawn_enemies() -> void:
	var enemies = get_tree().get_nodes_in_group("demons")
	if (enemies.size() < (actual_level + 1) * 15):
		if (player_ref != null):
			instantiate_for_lvl_0_to_4()
			instantiate_for_lvl_4_to_7()
			instantiate_for_lvl_7_to_10()
	else:
		# Too many enemies :P
		pass

func instantiate_for_lvl_0_to_4() -> void:
	if actual_level < 4:
		instantiate_demons(basic_demon_scene, 10, 25.0, 2)

func instantiate_for_lvl_4_to_7() -> void:
	if actual_level == 4:
		instantiate_demons(basic_demon_scene, 9, 25.0, 2)
		instantiate_demons(heavy_demon_scene, 1, 25.0, 10)
	if actual_level > 4 && actual_level < 7:
		instantiate_demons(basic_demon_scene, 8, 25.0, 2)
		instantiate_demons(heavy_demon_scene, 2, 25.0, 10)

func instantiate_for_lvl_7_to_10() -> void:
	if actual_level >= 7 && actual_level < 9:
		instantiate_demons(basic_demon_scene, 6, 25.0, 2)
		instantiate_demons(heavy_demon_scene, 2, 25.0, 10)
		instantiate_demons(fast_demon_scene, 2, 75, 2)
	if actual_level == 9:
		instantiate_demons(basic_demon_scene, 4, 25.0, 2)
		instantiate_demons(heavy_demon_scene, 3, 25.0, 10)
		instantiate_demons(fast_demon_scene, 3, 75, 2)

func instantiate_demons(demon_scene: PackedScene, amount: int, speed: float, hp: int) -> void:
	for i in range(0, amount):
		var demon = demon_scene.instantiate()
		var distance_to_player = Vector2(x_size + randi_range(0, 320), y_size + randi_range(0, 80))
		var position = player_ref.position + (distance_to_player * _get_relative_direction())
		demon.initialize(speed, player_ref, hp, position)
		add_child(demon)

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
	if actual_level < 10:
		gui._reset_exp()

func _on_angel_mejorado() -> void:
	pause_menu.is_accepted = true
	player_ref._on_angel_mejorado()

func _on_medium_mejorado() -> void:
	pause_menu.is_accepted = true
	player_ref._obtener_mejora()
	
func _spawn_santuario() -> void:
	level_up_sound.play()
	actual_level += 1
	var sanctuary = sanctuary_scene.instantiate()
	sanctuary.position = player_ref.position
	sanctuary.z_index = -1
	gui._add_life()
	add_child(sanctuary)
	gui._add_lvl()
	gui._reset_exp()
	if actual_level == 3:
		spawn_angel_defender()
	if actual_level == 6:
		spawn_attacking_angel()
	sanctuary_menu._show(actual_level)

func spawn_angel_defender() -> void:
	var defender_angel = defender_angel_scene.instantiate()
	var distance_to_player = Vector2(x_size + randi_range(0, 320), y_size + randi_range(0, 80))
	defender_angel.position = player_ref.position + (distance_to_player * _get_relative_direction())
	defender_angel.z_index = -1
	add_child(defender_angel)

func spawn_attacking_angel() -> void:
	var attacking_angel = attacking_angel_scene.instantiate()
	var distance_to_player = Vector2(x_size + randi_range(0, 320), y_size + randi_range(0, 80))
	attacking_angel.position = player_ref.position + (distance_to_player * _get_relative_direction())
	attacking_angel.z_index = -1
	add_child(attacking_angel)

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
