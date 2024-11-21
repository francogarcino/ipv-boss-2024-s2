extends PanelContainer

@onready var action_button: Button = $HBoxContainer/ActionButton
@onready var action_name_label: Label = $HBoxContainer/ActionNameLabel
@export var action_id: String
@export var action_name: String
@export var option: String

func _ready() -> void:
	set_process_input(false)
	action_button.text = action_id
	action_name_label.text = action_name

func _on_action_button_pressed() -> void:
	set_process_input(true)
	action_button.text = "..."
	action_button.release_focus()

func _input(event: InputEvent):
	if event is InputEventKey and event.pressed:
		action_id = event.as_text()
		action_button.text = action_id
		InputMap.action_erase_events(option)
		InputMap.action_add_event(option, event)
		set_process_input(false)
		action_button.grab_focus()
