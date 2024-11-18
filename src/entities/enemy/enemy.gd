extends CharacterBody2D
class_name Demon

const speed = 25.0
var target: Node2D
var max_hp: int = 2
var hp: int = 2
var push_velocity = Vector2.ZERO
var push_decay = 0.2

@onready var hp_progress: ProgressBar = $HpProgress
@onready var demon_animations: AnimationPlayer = $DemonAnimations
var hp_tween: Tween

func _ready() -> void:
	add_to_group("demons")
	hp_progress.max_value = max_hp
	hp_progress.value = hp
	hp_progress.modulate = Color.TRANSPARENT

func _process(delta: float) -> void:
	_play_animation("walk")
	if target:
		#var velocity = Vector2.ZERO
		var target_position = target.global_position
		velocity = (target_position - global_position).normalized() * speed
		
		velocity += push_velocity
		push_velocity = push_velocity.move_toward(Vector2.ZERO, push_decay)
		
		move_and_slide()

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body is Player:
		if has_active_sanctuaries():
			get_parent()._destroy_sanctuary()
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
	get_parent()._spawn_experience(global_position)
	deleted()

func deleted() -> void:
	get_parent().remove_child(self)
	queue_free()

func _play_animation(animation: String) -> void:
	if demon_animations.has_animation(animation):
		demon_animations.play(animation)
