extends Node

class_name Carrying

var target_resource : Harvestable
var target_dropoff : Unit
var inventory : Dictionary = {"food" : 0,
							  "protein" : 0,
							  "foliage" : 0}
@export var inventory_size : int = 10 ## quantity of resources this can hold
@export var pickup_distance : float = 0.5
@export var auto_drop_off : bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

	
func _physics_process(delta):
	_check_resource_collected()
	_check_dropoff()
	
# Returns the amount of inventory space left
func inventory_space_remaining() -> int:
	var remaining = inventory_size
	for key in inventory:
		remaining -= max(inventory[key], 0)
	return remaining

# Attempts to add resources to inventory. Returns the amounts that were added to inventory
# Input is a dictionary with resource types (as strings) as keys with associated amounts as ints
func add_all_to_inventory(amounts : Dictionary) -> Dictionary:
	# Dictionary to return later
	var amounts_added : Dictionary = {
		"food" : 0,
		"protein" : 0,
		"foliage" : 0 }
	
	# Add stuff to inventory
	for key in inventory:
		if amounts.has(key):
			var amount_added = min(inventory_space_remaining(), amounts[key])
			inventory[key] += amount_added
			amounts_added[key] += amount_added
			
	# Automatically drop it off
	if !auto_drop_off: return amounts # Abort if auto drop-off disabled
	# Add code to make ant drop off here
	return amounts

# Attempts to add resource to inventory. Returns the amount that was added to inventory
func add_type_to_inventory(res_type:String, amount:int) -> int:
	if !inventory.has(res_type):
		print("Error: Attempted to add nonexistent resource " + res_type + "to inventory")
	var remaining = inventory_space_remaining()
	var amount_added = min(amount, inventory_space_remaining())
	inventory[res_type] += amount_added
	return amount_added

func set_resource_target(resource) -> bool:
	if not resource is Harvestable:
		print("Error: set_resource_target passed something that wasn't Harvestable")
		return false
	target_resource = resource;
	if !get_parent().has_node("Movement"):
		print("Error: set_resource_target could not find parent's Movement")
		return false
	get_parent().get_node("Movement").set_destination(resource.position)
	return true
	
# Sets target for this unit to try drop off resources
# Should be a friendly building with spawning capability
# Returns true if target was set properly, false otherwise (ie target is not friendly building)
func set_dropoff_target(t : Unit) -> bool:
	# Safety checks
	if t.colony != get_parent().colony:
		return false
	if !t.has_node("Spawning"):
		print("Error: set_dropoff_target passed something that wasn't a friendly with Spawning")
		return false
	if !get_parent().has_node("Movement"):
		print("Error: set_dropoff_target could not find parent's Movement")
		return false
	get_parent().get_node("Movement").set_destination(t.position)
	target_dropoff = t
	return true

# Checks if unit reached the dropoff point.
# If it has, give resources to colony and empty inventory
func _check_dropoff():
	if !target_dropoff: return
	if inventory_space_remaining() == inventory_size: return
	if get_parent().position.distance_to(target_dropoff.position) > 4.0: return
	
	# Add resource to colony
	var colony = target_dropoff.colony
	colony.food += inventory["food"]
	colony.protein += inventory["protein"]
	colony.foliage += inventory["foliage"]
	# Empty inventory
	for key in inventory:
		inventory[key] = 0
	if auto_drop_off and target_resource != null: # Go get more
		set_resource_target(target_resource)
	else: # stop moving
		if get_parent().has_node("Movement"):
			get_parent().get_node("Movement").set_destination(get_parent().position)
	

func _check_resource_collected():
	if !target_resource: return;
	if inventory_space_remaining() <= 0: return
	var parent = get_parent()
	if parent.position.distance_to(target_resource.global_position) >= target_resource.radius + pickup_distance:
		return
	# If this point reached, checks passed and resource is in range
	var amount_added = add_type_to_inventory(target_resource.type, target_resource.amount)
	target_resource.decrease_amount(amount_added)
	# auto-drop off if enabled
	if not auto_drop_off: return
	var colony : Colony = get_parent().colony
	var best_target = null
	for node in get_tree().get_nodes_in_group(colony.group_name):
		if node.has_node("Spawning"):
			if best_target == null:
				best_target = node
			else:
				if get_parent().position.distance_to(node.position) < get_parent().position.distance_to(best_target.position):
					best_target = node
	if best_target != null:
		set_dropoff_target(best_target)

	return;
