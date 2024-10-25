extends Control

signal mejora_angel()
signal mejora_medium()

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide()

func _show():
	show()
	get_tree().paused = true

func _hide():
	hide()
	get_tree().paused = false

func _on_mejora_angel_button_pressed() -> void:
	_hide()
	emit_signal("mejora_angel")

func _on_mejora_medium_button_pressed() -> void:
	_hide()
	emit_signal("mejora_medium")
