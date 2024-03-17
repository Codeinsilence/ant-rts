extends Node

class_name Spawning

var worker_scene = preload("res://scenes/collision_ant.tscn")

var workers_per_interval = 1

var spawn_position_counter = 0
var spawn_distance = 2.0

func _on_spawn_time(colony):
	# spawn workers
	for i in range(workers_per_interval):
		if colony.pay_all(colony.cost_worker):
			spawn_worker(colony)

func spawn_worker(colony):
	var terrain = get_tree().get_root().get_node("/root/World/NavRegion/TerrainBody")
	var new_worker : Worker = worker_scene.instantiate()
	# Spawn in circle around building
	var spawn_offset = Vector3(sin(spawn_position_counter * 2.0 * PI / 5.0) * spawn_distance,
							   0.0, 
							   cos(spawn_position_counter * 2.0 * PI / 5.0) * spawn_distance);
	spawn_position_counter += 1
	new_worker.position = get_parent().position + spawn_offset
	new_worker.position.y = terrain.height_at(new_worker.position) + 0.05 # Fix height
	# Add to world
	get_tree().root.get_node("World").add_child(new_worker)
	# Set team info
	new_worker.set_selectionring_color(colony.team_color)
	new_worker.add_to_group(colony.group_name)
	# Make it walk a little farther
	var dest = get_parent().position + 3.0 * spawn_offset
	new_worker.set_destination(dest)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
