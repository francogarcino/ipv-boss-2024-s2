extends CharacterBody2D

@onready var body_animations: AnimationPlayer = $BodyAnimations

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _ready() -> void:
	initialize()


func initialize() -> void:
	pass


func _process_input() -> void:
	_play_animation("idle")


func _physics_process(delta: float) -> void:
	pass
	
	
func _play_animation(animation: String) -> void:
	if body_animations.has_animation(animation):
		body_animations.play(animation)
