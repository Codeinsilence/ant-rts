extends Node

var colony:Colony

# Keep track of nearby resources to send ants to
var nearby_harvestables := {"food": [],
							"protein": [],
							"foliage": []}

var time_since_harvestable_check:float = 0.0
var time_since_idle_check:float = -1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	colony = get_parent()
	pass # Replace with function body.

func _physics_process(delta):
	time_since_harvestable_check += delta
	if time_since_harvestable_check > 1.3:
		check_nearby_harvestables()
		time_since_harvestable_check = 0.0
	
	time_since_idle_check += delta
	if time_since_idle_check > 1.0:
		check_for_idles()
		time_since_idle_check = 0.0

func check_nearby_harvestables():
	# Loop over all harvestables
	for thing in get_tree().get_nodes_in_group("harvestables"):
		var new_target := thing as Harvestable
		var type = new_target.type
		# If we find a harvestable closer than one of the current nearby_harvestables, overwrite
		for i in range(nearby_harvestables[type].size()):
			if nearby_harvestables[type][i] == null:
				nearby_harvestables[type][i] = new_target
				break
			var old_target := nearby_harvestables[type][i] as Harvestable
			if new_target == old_target: break
			if colony.position.distance_to(new_target.position) < colony.position.distance_to(old_target.position):
				nearby_harvestables[type][i] = new_target
				break
		# Make sure we have up to 3 nearby_harvestables
		if nearby_harvestables[type].size() < 3:
			nearby_harvestables[type].append(new_target)

func check_for_idles():
	# Look for idle workers
	for unit in get_tree().get_nodes_in_group(colony.group_name):
		if unit is Worker:
			var worker := unit as Worker
			if worker.cur_action == "idle":
				# Idle worker found -> make it gather a random resource
				var rand_type = nearby_harvestables.keys()[randi_range(0, nearby_harvestables.keys().size()-1)]
				var i : int = randi_range(0, nearby_harvestables[rand_type].size()-1)
				worker.get_node("Carrying").set_resource_target(nearby_harvestables[rand_type][i])
				worker.get_node("Carrying").move_to_resource()
