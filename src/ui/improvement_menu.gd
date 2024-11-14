extends Control

signal mejora_angel()
signal mejora_medium()

@onready var label: Label = $Panel/Label
@onready var select_label: Label = $Panel/SelectLabel
@onready var improvement_angel_button: Button = $Panel/ImprovementAngelButton
@onready var improvement_medium_button: Button = $Panel/ImprovementMediumButton
@onready var select_button: Button = $Panel/SelectButton

func _ready() -> void:
	hide()
	hide_options()

func _show():
	label.visible = true
	select_button.visible = true
	show()
	get_tree().paused = true

func _hide():
	hide()
	get_tree().paused = false

func _on_improvement_angel_button_pressed() -> void:
	_hide()
	emit_signal("mejora_angel")
	hide_options()

func _on_improvement_medium_button_pressed() -> void:
	_hide()
	emit_signal("mejora_medium")
	hide_options()

func _on_select_button_pressed() -> void:
	label.visible = false
	select_button.visible = false
	select_label.visible = true
	improvement_angel_button.visible = true
	improvement_medium_button.visible = true

func hide_options() -> void:
	select_label.visible = false
	improvement_angel_button.visible = false
	improvement_medium_button.visible = false
