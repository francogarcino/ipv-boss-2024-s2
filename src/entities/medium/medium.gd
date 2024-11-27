extends CharacterBody2D
class_name Medium

signal subir_nivel()
signal invocar_santuario()
signal experiencia_obtenida()

@onready var collision_body: CollisionShape2D = $CollisionBody
@onready var body_pivot: Node2D = $BodyPivot
@onready var body_idle: Sprite2D = $BodyPivot/BodyIdle
@onready var body_run: Sprite2D = $BodyPivot/BodyRun
@onready var medium_animations: AnimationPlayer = $MediumAnimations
@onready var revive_timer: Timer = $ReviveTimer
@onready var angel: Node2D = $LinkedAngel
@onready var defense_angel: DefenseAngel = $DefenseAngel
@onready var explosive_angel: ExplosiveAngel = $ExplosiveAngel
@export var speed: float = 200
var projectile_container: Node
var experience_gained = 0
var actual_level = 0

func _ready() -> void:
	body_run.hide()

func _process_input(delta) -> void:
	if Input.is_action_just_pressed("angel_attack"):
		if projectile_container == null:
			projectile_container = get_parent()
		if angel.visible:
			if (angel.container == null):
				angel.set_container(projectile_container)
			angel.attackAt(get_global_mouse_position())
		elif explosive_angel.visible:
			if (explosive_angel.container == null):
				explosive_angel.set_container(projectile_container)
			explosive_angel.attackAt(get_global_mouse_position())
	
	velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed * delta

func _physics_process(delta: float) -> void:
	_process_input(delta)
	
	move_and_collide(velocity)
	
	var h_movement_direction: int = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	if h_movement_direction != 0:
		body_pivot.scale.x = 1 - 2 * float(h_movement_direction < 0)
	
	if (velocity.x == 0 && velocity.y == 0):
		_play_animation("idle")
		body_run.hide()
		body_idle.show()
	else:
		_play_animation("run")
		body_idle.hide()
		body_run.show()

func _on_angel_mejorado() -> void:
	angel._obtener_mejora()
	explosive_angel._obtener_mejora()

func _obtener_mejora() -> void:
	speed += speed * 0.5
	print("Medium speed increased!")

func _on_in_range_to_live_body_exited(body: Node2D) -> void:
	if body is Demon:
		body.deleted()

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body is Experience:
		body.deleted()
		experience_gained += 1
		if actual_level < 10:
			emit_signal("experiencia_obtenida")
		if actual_level < 10 && experience_gained == ((actual_level + 1) * 5):
			_level_up()
	elif body is DefenderAngel:
		body._remove()
		if (defense_angel.container == null):
			defense_angel.set_container(projectile_container)
		defense_angel.show()
	elif body is AttackingAngel:
		body._remove()
		angel.hide()
		explosive_angel.show()

func _level_up() -> void:
	actual_level += 1
	if actual_level % 3 == 0:
		emit_signal("invocar_santuario")
	else:
		emit_signal("subir_nivel")
	print("level_up: ", actual_level)

func _revive() -> void:
	collision_body.disabled = true
	revive_timer.start()

func _on_revive_timer_timeout() -> void:
	collision_body.disabled = false
	revive_timer.stop()

func _play_animation(animation: String) -> void:
	if medium_animations.has_animation(animation):
		medium_animations.play(animation)
