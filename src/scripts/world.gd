extends Node3D

var done_first_frame_setup = false

@onready var berry = preload("res://scenes/berry.tscn");
@onready var protein = preload("res://scenes/protein.tscn");
@onready var foliage = preload("res://scenes/leaf.tscn");

#number of resources in the world
var world_resources: Dictionary = { "food": 0,
									"protein": 0,
									"foliage": 0 }
var minimum_resources = 10

var rng = RandomNumberGenerator.new()

func _ready():
	pass

func _physics_process(delta):
	# Had to move this here to stop errors with navigation before NavMap exists
	if not done_first_frame_setup:
		$PlayerColony.spawn_starter_units()
		$EnemyColony.spawn_starter_units()
		_spawn_resources()
		done_first_frame_setup = true
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_respawn_resources()

	
func _spawn_resources():
	var terrain = $"NavRegion/TerrainBody"
	#Spawn Food (based off spawning ants)
	for i in range(minimum_resources):
		var instance = berry.instantiate();
		_spawning_location(instance, 10.0)
		instance.connect("foodCollected", $PlayerColony._on_food_collected);
		add_child(instance);
		world_resources["food"] += 1;
	
	for i in range(minimum_resources):
		var instance = protein.instantiate();
		_spawning_location(instance, 10.0)
		instance.connect("proteinCollected", $PlayerColony._on_protein_collected);
		add_child(instance);
		world_resources["protein"] += 1;
	
	#Spawn Foliage 
	for i in range(minimum_resources):
		var instance = foliage.instantiate();
		_spawning_location(instance, 0.1)
		instance.connect("leafCollected", $PlayerColony._on_leaf_collected);
		add_child(instance);
		world_resources["foliage"] += 1;

func _respawn_resources():
	var terrain = $"NavRegion/TerrainBody"
	
	for key in world_resources:
		var instance = null
		var drop_height = 10.0
		if world_resources[key] < minimum_resources:
			if key == "food":
				instance = berry.instantiate()
			elif key == "protein":
				instance = protein.instantiate()
			else:
				instance = foliage.instantiate()
				drop_height = 0.1
		if instance:
			_spawning_location(instance, drop_height)
			add_child(instance)
			world_resources[key] += 1
	return
	
func _spawning_location(instance: Harvestable, drop_height: float):
	var terrain = $"NavRegion/TerrainBody"
	while true:
		instance.position = position + Vector3(0, 0, 0);
		instance.position.x = rng.randf_range(20.0, 105.0);
		instance.position.z = rng.randf_range(20.0, 105.0);
		var available_space = _terrain_at(instance.position);
		if available_space:
			instance.position.y = terrain.height_at(instance.position) + drop_height;
			return

func _terrain_at(position: Vector3):
	var worldspace = get_world_3d().direct_space_state;
	var start = Vector3(position.x, 1000, position.z)
	var end = Vector3(position.x, -1000, position.z)
	var result = worldspace.intersect_ray(PhysicsRayQueryParameters3D.create(start, end))
	if result.collider.name == "TerrainBody":
		return true
	return false


func _on_background_audio_finished():
	var player = get_node("BackgroundAudio")
	player.play(0)
