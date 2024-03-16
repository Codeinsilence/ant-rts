extends Node

class_name Movement

#var object : Node3D
var location : Vector3
var destination: Vector3
var tangent : Vector3
var speed : float
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _set_destination(loc, dest):
	location = loc;
	destination = dest + Vector3(0.0, 0.05, 0.0);
	tangent = destination - location;
	
func _move(t) -> Array:
	if t < 0.0:
		t = 0.0
	if t > 1.0:
		t = 1.0
		
	var v1 = 2*pow(t, 3) - 3*pow(t, 2) + 1
	var v2 = pow(t, 3) - 2*pow(t, 2) + t
	var v3 = -2*pow(t, 3) + 3*pow(t, 2)
	var v4 = pow(t, 3) - pow(t, 2)
	
	var interp = (v1 * location) + (v2 * tangent) + (v3 * destination) + (v4 * tangent);
	if(interp == destination):
		return [];
	return [interp, tangent];

	
