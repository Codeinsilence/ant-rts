class_name Unit extends Node3D

# Adding properties
@export var health : float
@export var location: Vector3
@export var cur_action : String

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("selectable")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
