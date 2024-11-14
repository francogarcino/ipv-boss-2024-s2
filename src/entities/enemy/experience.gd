extends Node2D
class_name Experience

func _remove() -> void:
	get_parent().remove_child(self)
	queue_free()
