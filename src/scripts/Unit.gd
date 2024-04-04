class_name Unit extends CharacterBody3D


@export var max_health : int ## Max health (also starting health)
var health : int 			 ## Current health

@export var location: Vector3 ##location (global coordinates)

@export var cur_action : String ##the current action the unit is trying to perform

## Which colony this unit belongs to
var colony : Colony = null
 
func _ready():
	health = max_health
	# TEMPORARY LINE FOR TESTING HP BAR PLEASE DELETE LATER
	# health = randi_range(5, max_health)
	add_to_group("selectable")
	cur_action = "none"
	
func set_colony(col : Colony):
	colony = col
	add_to_group(col.group_name)
	set_selectionring_color(colony.team_color)
	
func set_selectionring_color(col : Color):
	if has_node("SelectionRing"):
		$SelectionRing.mesh.material.albedo_color = col

func add_to_selected_units():
	self.add_to_group("selected_units");
	if has_node("SelectionRing"):
		$SelectionRing.show()

func remove_from_selected_units():
	self.remove_from_group("selected_units");
	if has_node("SelectionRing"):
		$SelectionRing.hide()

func decrease_health(amt: float):
	health -= amt
