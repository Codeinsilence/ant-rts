extends Node3D

@export var team : String = "none"
@export var team_color : Color = Color(0.7, 0.7, 0.7, 1.0)

@onready var worker_scene = preload("res://scenes/collision_ant.tscn")
@onready var palace_scene = preload("res://scenes/palace.tscn")
@onready var group_name = get_groups()[0]

# Resource tracking
var food:int = 0 
var protein:int = 0
var foliage:int = 0
@export var food_initial:int = 50
@export var protein_initial:int = 0
@export var foliage_initial:int = 0

# Costs for units
var cost_worker = { "food" : 10,
					"protein" : 0,
					"foliage" : 0 }
					
var cost_palace = { "food" : 50,
					"protein" : 0,
					"foliage" : 100 }

var start_spawned = false

@export var spawn_interval : float = 15.0 # how often to spawn a batch of new ants
var spawn_timer : float

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
		instance.get_node("Spawning").spawn_worker(self)
		

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_timer = spawn_interval
	food = food_initial
	protein = protein_initial
	foliage = foliage_initial
	pass # Replace with function body.

func _physics_process(delta):
	_handle_spawn_timer(delta)

func pay_all(amounts : Dictionary) -> bool :
	# validate input
	if !amounts.has("food") or !amounts.has("protein") or !amounts.has("foliage"):
		print("Error: pay_all() given dictionary without proper keys")
		return false
	# check if we can pay the cost
	if amounts["food"] > food or amounts["protein"] > protein or amounts["foliage"] > foliage:
		return false
	# pay costs and return true
	food -= amounts["food"]
	protein -= amounts["protein"]
	foliage -= amounts["foliage"]
	return true

func pay_food(amount : int) -> bool : 
	if amount > food:
		return false
	food -= amount
	return true
	
func pay_protein(amount: int) -> bool : 
	if amount > protein:
		return false
	protein -= amount
	return true
	
func pay_foliage(amount: int) -> bool : 
	if amount > foliage:
		return false
	foliage -= amount
	return true

func _handle_spawn_timer(delta):
	spawn_timer -= delta
	
	if spawn_timer >= 0: return # abort if timer isn't done
	# If timer is done, spawn units
	spawn_timer = spawn_interval
	for member in get_tree().get_nodes_in_group(group_name):
		if member.has_node("Spawning"):
			member.get_node("Spawning")._on_spawn_time(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_leaf_collected():
	foliage = foliage + 1
	print("Player foliage: " + str(foliage))
