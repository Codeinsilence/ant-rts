# Initial Creator: George Power
# Purpose: Adds dynamic behavior to the HUD
extends Control

@onready var action_panel = get_node("ActionPanel")

# Called when the node enters the scene tree for the first time.
func _ready():
	action_panel.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(get_tree().get_nodes_in_group("selected_units").size() > 0 && action_panel.visible == false):
		action_panel.visible = true
	if(get_tree().get_nodes_in_group("selected_units").size() == 0 && action_panel.visible == true):
		action_panel.visible = false
	#for member in get_tree().get_nodes_in_group("selected_units"):
				#print(member)
				#if member.is_in_group("player"):
