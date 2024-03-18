extends Node

class_name Movement

#var object : Node3D
@onready var nav : NavigationAgent3D = $"../NavAgent"
var destination: Vector3
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

func set_destination(dest:Vector3):
	destination = dest;
	nav.set_target_position(dest)
	
func _on_velocity_computed(safe_velocity : Vector3) -> void:
	if nav.is_navigation_finished():
		pass
	var parent = get_parent()
	look_at(parent.position + safe_velocity) # Face forward
	parent.velocity = safe_velocity
	parent.move_and_slide()

