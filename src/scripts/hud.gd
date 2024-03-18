# Initial Creator: George Power
# Purpose: Adds dynamic behavior to the HUD
extends Control

@onready var action_panel = get_node("ActionPanel")

var selected_units: Array

@onready var portrait = action_panel.get_node("GridContainer/UnitPortrait")
@onready var stat_panel = action_panel.get_node("GridContainer/UnitStats")
@onready var actions = action_panel.get_node("GridContainer/UnitActions")

@onready var hud_hp = stat_panel.get_node("GridContainer/Health/HBoxContainer/Value")
@onready var hud_speed = stat_panel.get_node("GridContainer/Speed/HBoxContainer/Value")

func _ready():
	action_panel.visible = false

func _process(delta):
	## Hide the panel unless a unit is selected
	var num_selected = get_tree().get_nodes_in_group("selected_units").size()
	if(num_selected > 0 && action_panel.visible == false):
		action_panel.visible = true
	if(num_selected == 0 && action_panel.visible == true):
		action_panel.visible = false
		hud_hp.text = "0"
		hud_speed.text = "0"
	
	for unit in get_tree().get_nodes_in_group("selected_units"):
		if(unit.is_in_group("player") or unit.is_in_group("enemy")):
			_update_action_panel(unit)
			#selected_units.append(unit)
			#selected_units.reduce()

func _update_action_panel(unit: Unit):
	hud_hp.text = str(unit.health)
	var movement: Movement = unit.get_node_or_null("Movement")
	if(movement != null):
		hud_speed.text = str(movement.speed)
	else:
		hud_speed.text = "0"
