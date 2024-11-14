extends Control

signal start()

func _ready() -> void:
	_show()

func _show():
	show()
	get_tree().paused = true

func _on_start_button_pressed() -> void:
	hide()
	get_tree().paused = false
	emit_signal("start")

func _on_exit_button_pressed() -> void:
	get_tree().quit()
