class_name Harvestable extends Node3D

@export var type: String
@export var radius : float = 1.5
@export var starting_amount : int = 50
var amount = 0
var location: Vector3

signal leafCollected
signal proteinCollected
signal foodCollected

# Called when the node enters the scene tree for the first time.
func _ready():
	amount = starting_amount

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Decreases the amount of resource left on this node, up to a max of the amount left
# Returns the amount that was lost
func decrease_amount(n:int) -> int:
	var taken = min(n, amount)
	amount -= taken
	if amount <= 0 : _remove_from_world(type);
	return taken
	
func _remove_from_world(t: String):
	queue_free(); 
	var world = get_tree().get_root().get_node("World")
	world.world_resources[t] -= 1

func harvest_self():
	self.queue_free()
	if(type == "food"):
		emit_signal("foodCollected")
	if(type == "protein"):
		emit_signal("proteinCollected")
	if(type == "foliage"):
		emit_signal("leafCollected")

