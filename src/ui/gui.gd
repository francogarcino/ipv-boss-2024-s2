extends Control

@onready var label: Label = $StatsContainer/Label
@onready var amount_of_lifes: Label = $StatsContainer/AmountOfLifes
@onready var amount_of_sanctuaries: Label = $StatsContainer/AmountOfSanctuaries

func _add_life() -> void:
	amount_of_lifes.text = str(int(amount_of_lifes.text) + 1)
	amount_of_sanctuaries.text = str(int(amount_of_sanctuaries.text) + 1)

func _lose_life() -> void:
	amount_of_lifes.text = str(int(amount_of_lifes.text) - 1)
	amount_of_sanctuaries.text = str(int(amount_of_sanctuaries.text) - 1)
