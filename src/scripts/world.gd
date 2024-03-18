extends Node3D

var done_first_frame_setup = false

@onready var berry = preload("res://scenes/berry.tscn");
@onready var foliage = preload("res://scenes/leaf.tscn");
var rng = RandomNumberGenerator.new()

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	# Had to move this here to stop errors with navigation before NavMap exists
	if not done_first_frame_setup:
		$PlayerColony.spawn_starter_units()
		$EnemyColony.spawn_starter_units()
		_spawn_resources()
		done_first_frame_setup = true
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _spawn_resources():
	var terrain = $"NavRegion/TerrainBody"
	#Spawn Food (based off spawning ants)
	for i in range(5):
		var instance = berry.instantiate();
		instance.position = position + Vector3(0, 0, 0);
		instance.position.x = rng.randf_range(10.0, 100.0);
		instance.position.z = rng.randf_range(10.0, 100.0);
		instance.position.y = terrain.height_at(instance.position) + 0.1;
		instance.connect("foodCollected", $PlayerColony._on_food_collected);
		add_child(instance);
	
	#Spawn Foliage 
	for i in range(5):
		var instance = foliage.instantiate();
		instance.position = position + Vector3(0, 0, 0);
		instance.position.x = rng.randf_range(10.0, 100.0);
		instance.position.z = rng.randf_range(10.0, 100.0);
		instance.position.y = terrain.height_at(instance.position) + 0.1;
		instance.connect("leafCollected", $PlayerColony._on_leaf_collected);
		add_child(instance);
