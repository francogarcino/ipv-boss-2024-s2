extends PanelContainer

@export var action: String
@export var action_name: String

@onready var action_key_button: Button = %ActionKeyButton
@onready var action_name_label: Label = %ActionNameLabel

func _set_action_name(nm: String) -> void:
	action_name = nm
	if has_node("%ActionNameLabel"):
		$"%ActionNameLabel".text = nm
