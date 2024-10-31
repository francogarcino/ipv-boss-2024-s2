extends CharacterBody2D
class_name Player

signal subir_nivel()

@onready var angel: Node2D = $LinkedAngel
@export var speed: float = 300.0
var projectile_container: Node

func _ready() -> void:
	angel.subir_nivel.connect(_on_mejora_conseguida)

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

func _on_mejora_conseguida() -> void:
		emit_signal("subir_nivel")

func _on_angel_mejorado() -> void:
	angel._obtener_mejora()

func _obtener_mejora() -> void:
	speed += speed * 0.5
	print("Medium speed increased!")


func _on_in_range_to_live_body_exited(body: Node2D) -> void:
	if body is Demon:
		body.queue_free()
	#pass
