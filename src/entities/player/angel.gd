extends Node2D

@onready var angel_tip = $AngelTip

@export var projectile_scene: PackedScene
var projectile_container: Node

var attacking: bool = false

func fire() -> void:
	if (!attacking):
		attacking = true
		var mouse_position: Vector2 = get_global_mouse_position()
		var projectile_instance = projectile_scene.instantiate()
		projectile_container.add_child(projectile_instance)
		projectile_instance.initialize(projectile_container, angel_tip.global_position, global_position.direction_to(mouse_position))
		projectile_instance.delete_requested.connect(_on_projectile_delete_requested)
		hide()


func _on_projectile_delete_requested(projectile):
	projectile_container.remove_child(projectile)
	projectile.queue_free()
	show()
	attacking = false
