extends CharacterBody2D
class_name Demon

@onready var body: Sprite2D = $Body
var speed: float
var target: Node2D
var offset: Vector2 = Vector2.ZERO
var max_hp: int
var hp: int
var push_velocity = Vector2.ZERO
var push_decay = 0.2
var score: int

@onready var hp_progress: ProgressBar = $HpProgress
@onready var demon_animations: AnimationPlayer = $DemonAnimations
var hp_tween: Tween

func _ready() -> void:
	add_to_group("demons")
	offset = Vector2(randi_range(-15, 15), randi_range(-25, 25))
	hp_progress.max_value = hp
	hp_progress.value = hp
	hp_progress.modulate = Color.TRANSPARENT

func initialize(speed: float, target: Node2D, hp: int, spawn_position: Vector2, score: int) -> void:
	self.speed = speed
	self.target = target
	self.max_hp = hp
	self.hp = hp
	position = spawn_position
	self.score = score

func _process(delta: float) -> void:
	_play_animation("walk")
	if target:
		var target_position = target.global_position + offset
		velocity = (target_position - global_position).normalized() * speed
		
		velocity += push_velocity
		push_velocity = push_velocity.move_toward(Vector2.ZERO, push_decay)
		
		move_and_slide()
		
		body.flip_h = (target.global_position - global_position).x < 0

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body is Medium:
		if has_active_sanctuaries():
			get_parent()._destroy_sanctuary()
			var direction = (global_position - body.global_position).normalized()
			push_velocity = direction * 80.0
		else:
			print('Player detected!')
			get_parent()._player_defeated()

func has_active_sanctuaries() -> bool:
	return get_tree().get_nodes_in_group("sanctuaries").size() > 0

func hit(amount: int) -> void:
	hp = clamp(hp - amount, 0, max_hp)
	hp_progress.value = hp
	if hp <= 0:
		_remove()
	if hp_tween:
		hp_tween.kill()
	hp_tween = create_tween()
	hp_progress.modulate = Color.WHITE
	hp_tween.tween_property(hp_progress, "modulate", Color.TRANSPARENT, 5.0)

func _remove() -> void:
	var container = get_parent()
	deleted()
	container._spawn_experience_and_score_addition(global_position, score)

func deleted() -> void:
	get_parent().remove_child(self)
	queue_free()

func _play_animation(animation: String) -> void:
	if demon_animations.has_animation(animation):
		demon_animations.play(animation)
