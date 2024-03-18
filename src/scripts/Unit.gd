class_name Unit extends CharacterBody3D

##current health
@export var health : int
##location (global coordinates)
@export var location: Vector3
##the current action the unit is trying to perform
@export var cur_action : String

func _ready():
	add_to_group("selectable")

func add_to_selected_units():
	self.add_to_group("selected_units");
	$SelectionRing.show()

func set_selectionring_color(col : Color):
	$SelectionRing.mesh.material.albedo_color = col

func remove_from_selected_units():
	self.remove_from_group("selected_units");
	$SelectionRing.hide()
