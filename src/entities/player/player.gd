extends CharacterBody2D
class_name Player

signal subir_nivel()
signal invocar_santuario()

@onready var angel: Node2D = $LinkedAngel
@onready var defense_angel: DefenseAngel = $DefenseAngel
@export var speed: float = 150.0
var projectile_container: Node
var experience_gained = 0
var actual_level = 0

func _process_input(delta) -> void:
	if Input.is_action_just_pressed("angel_attack"):
		if projectile_container == null:
			projectile_container = get_parent()
		if (angel.container == null):
			angel.set_container(projectile_container)
		angel.attackAt(get_global_mouse_position())
	
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		
	position += velocity * delta

func _physics_process(delta: float) -> void:
	_process_input(delta)

func _on_angel_mejorado() -> void:
	angel._obtener_mejora()

func _obtener_mejora() -> void:
	speed += speed * 0.5
	print("Medium speed increased!")

func _on_in_range_to_live_body_exited(body: Node2D) -> void:
	if body is Demon:
		body.deleted()

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body is Experience:
		body._remove()
		experience_gained += 1
		if actual_level < 10 && experience_gained == ((actual_level + 1) * 2):
			_level_up()
	elif body is DefenderAngel:
		body._remove()
		defense_angel.show()

func _level_up() -> void:
	actual_level += 1
	if actual_level % 3 == 0:
		emit_signal("invocar_santuario")
	else:
		emit_signal("subir_nivel")
	print("level_up: ", actual_level)
