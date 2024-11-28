extends Control

@onready var timer: Timer = $Timer

func _ready() -> void:
	hide()

func _show() -> void:
	show()
	timer.start()

func _on_timer_timeout() -> void:
	timer.stop()
	hide()
