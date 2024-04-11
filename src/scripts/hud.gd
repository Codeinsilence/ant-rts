# Initial Creator: George Power
# Purpose: Adds dynamic behavior to the HUD
extends Control

@onready var status_bar = get_node("StatusBar")
@onready var hud_food = status_bar.get_node("GridContainer/Food/HBoxContainer/Value")
@onready var hud_protein = status_bar.get_node("GridContainer/Protein/HBoxContainer/Value")
@onready var hud_foliage = status_bar.get_node("GridContainer/Foliage/HBoxContainer/Value")
@onready var hud_capacity = status_bar.get_node("GridContainer/Capacity/HBoxContainer/Value")

@onready var action_panel = get_node("ActionPanel")
@onready var stat_panel = action_panel.get_node("GridContainer/UnitStats")
@onready var actions = action_panel.get_node("GridContainer/UnitActions")
@onready var hud_hp = stat_panel.get_node("GridContainer/Health/HBoxContainer/Value")
@onready var hud_speed = stat_panel.get_node("GridContainer/Speed/HBoxContainer/Value")
@onready var hud_action = stat_panel.get_node("GridContainer/Action/HBoxContainer/Value")
@onready var hud_portrait = action_panel.get_node("GridContainer/UnitPortraitBG/UnitPortrait")
@onready var hud_portrait_bg = action_panel.get_node("GridContainer/UnitPortraitBG")

@onready var portrait_default = preload("res://assets/portraits/unknownPortrait.png")

@onready var inventory_container = get_node("ActionPanel/GridContainer/UnitActions/InventoryContainer")
@onready var unit_food_val = inventory_container.get_node("Food/HBoxContainer/Value")
@onready var unit_protein_val = inventory_container.get_node("Protein/HBoxContainer/Value")
@onready var unit_foliage_val = inventory_container.get_node("Foliage/HBoxContainer/Value")

var _colony = null

func _ready():
	action_panel.visible = false

func _physics_process(delta):
	pass
	_update_status_bar(_colony)

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
	hud_action.text = unit.cur_action
	
	# update for unit inventory
	if(unit.has_node("Carrying")):
		inventory_container.visible = true
		var carrying_node = unit.get_node("Carrying")
		var inventory = carrying_node.inventory
		unit_food_val.text = str(inventory.food)
		unit_protein_val.text = str(inventory.protein)
		unit_foliage_val.text = str(inventory.foliage)
	else:
		inventory_container.visible = false
	
	if(unit.portrait != null):
			hud_portrait.texture = unit.portrait
			hud_portrait_bg.material.set("shader_parameter/bg_color", unit.colony.team_color);
	else:
		hud_portrait.texture = portrait_default
		hud_portrait_bg.material.set("shader_parameter/bg_color", Vector4(0,0,0,1));
		
	

func _update_status_bar(colony):
	if(colony == null): return
	
	hud_food.text = str(colony.food)
	hud_protein.text = str(colony.protein)
	hud_foliage.text = str(colony.foliage)
	hud_capacity.text = str(colony.ants) + "/" + str(colony.houses * colony.capacity_per_house)

func _on_player_colony_ready():
	var player_units = get_tree().get_nodes_in_group("player")
	for unit in player_units:
		if(unit.name == "PlayerColony"):
			_colony = unit
