extends Control

@onready var sanctuary_label: Label = $Panel/SanctuaryLabel
@onready var sanctuary_and_angel_label: Label = $Panel/SanctuaryAndAngelLabel

func _ready() -> void:
	hide()
	sanctuary_and_angel_label.visible = false

func _show(level: int):
	if level == 3 || level == 6:
		sanctuary_label.visible = false
		sanctuary_and_angel_label.visible = true
	show()
	get_tree().paused = true

func _hide():
	hide()
	get_tree().paused = false

func _on_exit_button_pressed() -> void:
	_hide()
	sanctuary_label.visible = true
	sanctuary_and_angel_label.visible = false
