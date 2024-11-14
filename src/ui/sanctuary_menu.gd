extends Control

func _ready() -> void:
	hide()

func _show():
	show()
	get_tree().paused = true

func _hide():
	hide()
	get_tree().paused = false

func _on_exit_button_pressed() -> void:
	_hide()
