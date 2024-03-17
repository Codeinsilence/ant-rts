extends StaticBody3D

func height_at(pos: Vector3):
	var worldspace = get_world_3d().direct_space_state;
	var start = Vector3(pos.x, 500, pos.z)
	var end = Vector3(pos.x, -500, pos.z)
	var result = worldspace.intersect_ray(PhysicsRayQueryParameters3D.create(start, end))
	return result.position.y


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
