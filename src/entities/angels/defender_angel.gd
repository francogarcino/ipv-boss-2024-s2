extends Node2D
class_name DefenderAngel

func _remove() -> void:
	get_parent().remove_child(self)
	queue_free()
