extends Node2D
class_name Sanctuary

func _ready() -> void:
	add_to_group("sanctuaries")

func _remove() -> void:
	get_parent().remove_child(self)
	queue_free()
