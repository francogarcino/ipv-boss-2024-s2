extends Node2D
class_name Experience

func deleted() -> void:
	get_parent().remove_child(self)
	queue_free()
