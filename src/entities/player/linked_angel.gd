extends Node2D
class_name Angel

@onready var attack_timer: Timer = $AttackTimer
@export var speed: float = 400.0
var attacking: bool = false 
var expected_coord: Vector2
var container: Node2D
var initial_attack_position: Vector2

func _physics_process(delta: float) -> void:
	if(attacking):
		self.position += expected_coord * speed * delta

func attackAt(position: Vector2) -> void:
	if(!attacking):
		initial_attack_position = global_position
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
	var player = get_parent().get_node("Player")
	get_parent().remove_child(self)
	player.add_child(self)
	global_position = initial_attack_position

func _on_detection_area_body_entered(body: Node2D) -> void:
	# not working :_(
	if body is Demon:
		print("Attacked o:) ")
		body.queue_free()

func _attacking() -> bool:
	return self.attacking
