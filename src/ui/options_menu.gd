extends Control

var controls = {
	"move_up": "W",
	"move_down": "S",
	"move_left": "A",
	"move_right": "D"
}

@onready var buttons = {
	"move_up": $Panel/Panel/ScrollContainer/VBoxContainer/ActionMap/HBoxContainer/MoveUpButton,
	"move_left": $Panel/Panel/ScrollContainer/VBoxContainer/ActionMap2/HBoxContainer/MoveLeftButton,
	"move_right": $Panel/Panel/ScrollContainer/VBoxContainer/ActionMap3/HBoxContainer/MoveRightButton,
	"move_down":$Panel/Panel/ScrollContainer/VBoxContainer/ActionMap4/HBoxContainer/MoveDownButton,
}

var awaiting_input: String = ""

func _ready() -> void:
	hide()
	#_load_controls()
	#for action in buttons.keys():
	#	buttons[action].text = controls[action]

func _on_return_button_pressed() -> void:
	hide()

func _on_button_pressed(action: String):
	awaiting_input = action
	buttons[action].text = "..."
	buttons[action].release_focus()

func _input(event: InputEvent):
	if awaiting_input != "" and event is InputEventKey and event.pressed:
		var action = awaiting_input
		awaiting_input = ""
		controls[action] = event.as_text()
		buttons[action].text = event.as_text()
		InputMap.action_erase_events(action)
		InputMap.action_add_event(action, event)
		buttons[action].grab_focus()
		#_save_controls()

func _on_move_up_button_pressed() -> void:
	_on_button_pressed("move_up")

func _on_move_left_button_pressed() -> void:
	_on_button_pressed("move_left")

func _on_move_right_button_pressed() -> void:
	_on_button_pressed("move_right")

func _on_move_down_button_pressed() -> void:
	_on_button_pressed("move_down")

func _save_controls():
	var config = ConfigFile.new()
	for action in controls.keys():
		config.set_value("controls", action, controls[action])
	config.save("user://controls.cfg")

func _load_controls():
	var config = ConfigFile.new()
	if config.load("user://controls.cfg") == OK:
		for action in buttons.keys():
			var key_name = config.get_value("controls", action, controls.get(action, "Undefined"))
			controls[action] = key_name
			_update_input_map(action, _get_keycode_from_name(key_name))
	else:
		controls = {
			"move_up": "Key.W",
			"move_down": "Key.S",
			"move_left": "Key.A",
			"move_right": "Key.D"
		}
		for action in controls.keys():
			_update_input_map(action, _get_keycode_from_name(controls[action]))
		_save_controls()

func _update_input_map(action: String, physical_keycode: int):
	InputMap.action_erase_events(action)
	var new_event = InputEventKey.new()
	new_event.physical_keycode = physical_keycode
	new_event.pressed = false
	InputMap.action_add_event(action, new_event)

func _get_keycode_from_name(key_name: String) -> int:
	match key_name:
		"Key.W": return KEY_W
		"Key.S": return KEY_S
		"Key.A": return KEY_A
		"Key.D": return KEY_D
		_: return -1
