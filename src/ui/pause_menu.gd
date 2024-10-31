extends Control

signal retry()

@onready var options_menu: Control = $OptionsMenu
var is_accepted: bool = false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide()

func _unhandled_input(event: InputEvent) -> void:
	if is_accepted && event.is_action_released("pause_menu") && !options_menu.visible:
		visible = !visible
		get_tree().paused = visible

func _show():
	show()
	get_tree().paused = true

func _hide():
	hide()
	get_tree().paused = false

func _on_restart_button_pressed() -> void:
	hide()
	emit_signal("retry")

func _on_return_button_pressed() -> void:
	_hide()
