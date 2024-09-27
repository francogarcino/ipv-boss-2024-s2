extends CharacterBody2D

@onready var angel: Node2D = $"%Angel"

var projectile_container: Node

const speed = 400.0


func _process_input(delta) -> void:
	if Input.is_action_just_pressed("angel_attack"):
		if projectile_container == null:
			projectile_container = get_parent()
		if angel.projectile_container == null:
			angel.projectile_container = projectile_container
		angel.fire()
	
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
