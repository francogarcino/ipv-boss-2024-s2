extends Node2D
class_name DefenseAngel

@onready var attack_timer: Timer = $AttackTimer
@onready var angel_attack_sound: AudioStreamPlayer2D = $AngelAttackSound

var demons_in_area: Array = []
var attacking: bool = false

func _ready() -> void:
	hide()
	
func _physics_process(delta: float) -> void:
	if (visible && !attacking && !demons_in_area.is_empty()):
		attacking = true
		attack()
		attack_timer.start()

func attack() -> void:
	for demon in demons_in_area:
		demon.hit(1)
		var direction = (demon.global_position - global_position).normalized()
		demon.push_velocity = direction * 40.0

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body is Demon:
		demons_in_area.push_back(body)

func _on_hitbox_body_exited(body: Node2D) -> void:
	if body is Demon:
		demons_in_area.pop_at(demons_in_area.find(body))

func _on_attack_timer_timeout() -> void:
	attack_timer.stop()
	attacking = false
