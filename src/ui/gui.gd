extends Control

@onready var label: Label = $StatsContainer/Label
@onready var amount_of_lifes: Label = $StatsContainer/AmountOfLifes
@onready var amount_of_sanctuaries: Label = $StatsContainer/AmountOfSanctuaries
@onready var lvl: Label = $StatsContainer/Panel/Lvl
@onready var exp_progress: ProgressBar = $StatsContainer/ExpProgress

func _add_life() -> void:
	amount_of_lifes.text = str(int(amount_of_lifes.text) + 1)
	amount_of_sanctuaries.text = str(int(amount_of_sanctuaries.text) + 1)

func _lose_life() -> void:
	amount_of_lifes.text = str(int(amount_of_lifes.text) - 1)
	amount_of_sanctuaries.text = str(int(amount_of_sanctuaries.text) - 1)

func _add_lvl() -> void:
	lvl.text = str(int(lvl.text) + 1)

func _add_exp() -> void:
	exp_progress.value += 1

func _reset_exp() -> void:
	exp_progress.value = 0
	
