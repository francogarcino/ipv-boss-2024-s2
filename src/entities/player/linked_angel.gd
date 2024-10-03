extends Node2D
class_name Angel

@onready var attack_timer: Timer = $AttackTimer
@export var speed: float = 400.0
var attacking: bool = false 
var expected_coord: Vector2
var container: Node2D
var medium: Node2D

func _physics_process(delta: float) -> void:
	if(attacking):
		self.position += expected_coord * speed * delta

func attackAt(position: Vector2) -> void:
	if(!attacking):
		container.add_child(self)
		expected_coord = global_position.direction_to(position)
		attacking = true
		attack_timer.start()


func _on_attack_timer_timeout() -> void:
	attacking = false
	attack_timer.stop()
	self._return_to_player()
	

func set_container(container: Node2D) -> void:
	self.container = container

func _return_to_player():
	global_position = medium.global_position

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body is Demon:
		print("Attacked o:) ")
		body.queue_free()
		_on_attack_timer_timeout()

func _attacking() -> bool:
	return self.attacking
