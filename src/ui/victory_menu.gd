extends Control

signal retry()

@onready var score_label: Label = $Panel/ScoreLabel

func _ready() -> void:
	hide()

func _show(score: String):
	score_label.text += score
	show()
	get_tree().paused = true

func _on_restart_button_pressed() -> void:
	hide()
	emit_signal("retry")
