class_name Colony extends Node3D

@onready var worker_scene = preload("res://scenes/worker.tscn")
@onready var palace_scene = preload("res://scenes/palace.tscn")
@onready var house_scene = preload("res://scenes/house.tscn")
@onready var group_name = get_groups()[0]

@export var team : String = "none" ##Specify the team name
@export var team_color : Color = Color(0.7, 0.7, 0.7, 1.0) ##Specify the team color (affects all units and buildings)
@export var food_initial:int = 50 ##Specify the initial value for the food supply
@export var protein_initial:int = 0 ##Specify the initial value for the protein supply
@export var foliage_initial:int = 0 ##Specify the initial value for the foliage supply
@export var spawn_interval : float = 15.0 ##Specify the time needed for the Palace to spawn a new unit

# Resource tracking
var food:int = 0 
var protein:int = 0
var foliage:int = 0

# Building/ant tracking
var ants: int = 0
var houses: int = 0
var capacity_per_house: int = 30 # going to hardcode this value in colony for now until something better comes up

# Costs for units
var cost_worker = { "food" : 50,
					"protein" : 0,
					"foliage" : 0 }
					
var cost_palace = { "food" : 300,
					"protein" : 50,
					"foliage" : 300 }

var start_spawned = false

var spawn_timer : float

func spawn_starter_units():
	var terrain = $"../NavRegion/TerrainBody" # reference to terrain for later
	var world = get_parent()
	# Spawn a palace
	var instance : Palace = palace_scene.instantiate()
	instance.position = position + Vector3(0, 0, 0)
	instance.position.y = terrain.height_at(instance.position) + 0.1 # Fix height to just above terrain
	instance.set_colony(self)
	world.add_child(instance)
	_spawn_starting_house() #test for spawning an initial house
	# Spawn 3 workers
	for i in range(3):
		instance.get_node("Spawning").spawn_worker(self)
		ants += 1

func _ready():
	spawn_timer = spawn_interval
	food = food_initial
	protein = protein_initial
	foliage = foliage_initial
	

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
	if houses * capacity_per_house <= ants: return # abort if not enough houses
	# If timer is done, spawn units
	spawn_timer = spawn_interval
	for member in get_tree().get_nodes_in_group(group_name):
		if member.has_node("Spawning"):
			member.get_node("Spawning")._on_spawn_time(self)
			ants += 1

func _spawn_starting_house():
	var terrain = $"../NavRegion/TerrainBody"
	var world = get_parent()
	var instance : House = house_scene.instantiate()
	instance.position = position + Vector3(0, 0, 0)
	var offset = Vector3(0, 0, 0)
	if(instance.position.x >= 100):
		offset.x += 10
		offset.z += 10
	else:
		offset.x -= 10
		offset.z -= 10
	instance.position += offset
	instance.position.y = terrain.height_at(instance.position) + 0.1 
	instance.set_colony(self)
	world.add_child(instance)
	houses += 1
	return
	
func _single_ant_killed():
	ants -= 1
	return

func _on_leaf_collected():
	foliage = foliage + 1
	print("Player foliage: " + str(foliage))

func _on_food_collected():
	food = food + 1
	print("Player food: " + str(food))

func _on_protein_collected():
	protein = protein + 1
	print("Player protein: " + str(protein))
