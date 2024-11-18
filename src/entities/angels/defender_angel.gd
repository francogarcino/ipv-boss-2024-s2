extends Node2D
class_name DefenderAngel

@onready var angel_animations: AnimationPlayer = $AngelAnimations

func _ready() -> void:
	_play_animation("idle")

func _remove() -> void:
	get_parent().remove_child(self)
	queue_free()

func _play_animation(animation: String) -> void:
	if angel_animations.has_animation(animation):
		angel_animations.play(animation)
