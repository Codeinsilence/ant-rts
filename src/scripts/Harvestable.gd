class_name Harvestable extends Node3D

@export var type: String
var location: Vector3

signal leafCollected
signal proteinCollected
signal foodCollected

# Called when the node enters the scene tree for the first time.
func _ready():
	location = self.global_position;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func harvest_self():
	self.queue_free()
	if(type == "food"):
		emit_signal("foodCollected")
	if(type == "protein"):
		emit_signal("proteinCollected")
	if(type == "foliage"):
		emit_signal("leafCollected")

