extends Node

class_name Movement

#var object : Node3D
@onready var nav : NavigationAgent3D = $"../NavAgent"
var location : Vector3
var destination: Vector3
var tangent : Vector3
@export var speed : float

func look_at(target : Vector3):
	var parent = get_parent()
	if target.is_equal_approx(parent.position):
		return # Stop the screaming
	parent.look_at(target)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	nav = $"../NavAgent"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	if nav.is_navigation_finished(): return # Abort if we reach destination
	# Note: Only *attempts* to move on this velocity. Actual movement on _on_veclocity_computed()
	nav.velocity = $"../".position.direction_to(nav.get_next_path_position()) * speed

func _set_destination(loc, dest:Vector3):
	location = loc;
	destination = dest;
	tangent = destination - location;
	nav.set_target_position(dest)
	
func _on_velocity_computed(safe_velocity : Vector3) -> void:
	if nav.is_navigation_finished():
		pass
	var parent = get_parent()
	look_at(parent.position + safe_velocity) # Face forward
	parent.velocity = safe_velocity
	parent.move_and_slide()

#func _move(t) -> Array:
	#if t < 0.0:
		#t = 0.0
	#if t > 1.0:
		#t = 1.0
		#
	#var v1 = 2*pow(t, 3) - 3*pow(t, 2) + 1
	#var v2 = pow(t, 3) - 2*pow(t, 2) + t
	#var v3 = -2*pow(t, 3) + 3*pow(t, 2)
	#var v4 = pow(t, 3) - pow(t, 2)
	#
	#var interp = (v1 * location) + (v2 * tangent) + (v3 * destination) + (v4 * tangent);
	#if(interp == destination):
		#return [];
	#return [interp, tangent];
