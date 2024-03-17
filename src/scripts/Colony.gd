extends Node3D

@export var team : String = "none"
@export var team_color : Color = Color(0.7, 0.7, 0.7, 1.0)

@onready var worker_scene = preload("res://scenes/collision_ant.tscn")
@onready var palace_scene = preload("res://scenes/palace.tscn")
@onready var group_name = get_groups()[0]

var food:int = 0 
var protein:int = 0
var leaves:int = 0

var start_spawned = false

func spawn_starter_units():
	var terrain = $"../NavRegion/TerrainBody" # reference to terrain for later
	var world = get_parent()
	# Spawn a palace
	var instance = palace_scene.instantiate()
	instance.position = position + Vector3(0, 0, 0)
	instance.position.y = terrain.height_at(instance.position) + 0.1 # Fix height to just above terrain
	instance.add_to_group(group_name)
	world.add_child(instance)
	# Spawn 3 workers
	for i in range(3):
		instance = worker_scene.instantiate()
		instance.position = position + Vector3(sin(i) * 4.0, 0, cos(i) * 4.0)
		instance.position.y = terrain.height_at(instance.position) + 0.1 # Fix height to just above terrain
		instance.set_selectionring_color(team_color)
		instance.add_to_group(group_name)
		get_parent().add_child(instance)
		

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
