extends Control

signal retry()

func _ready() -> void:
	hide()

func _show():
	show()
	get_tree().paused = true

func _on_restart_button_pressed() -> void:
	hide()
	emit_signal("retry")
