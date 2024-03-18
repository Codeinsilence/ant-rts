extends Node

class_name Carrying

var target_resource : Node3D
var unit_location : Vector3
var inventory : Array
var carry_distance = 1.7

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_check_resource_collected()

func _add_to_inventory(resource):
	inventory.append(resource);

func _set_resource_target(resource):
	target_resource = resource;

func _check_resource_collected():
	if(!target_resource):
		return;
		
	var parent = get_parent()
	if parent.position.distance_to(target_resource.global_position) <= carry_distance:
		_add_to_inventory(target_resource);
		target_resource.harvest_self();
	return;
