extends CollisionShape3D


# Called when the node enters the scene tree for the first time.
func _ready():
	var mesh = get_node("../TerrainMesh")
	var size = mesh.size
	var data = mesh.heightmap
	#var data = PackedFloat32Array()
	#for i in range(size):
		#for j in range(size):
			#data.append(0.0)
	
	shape.map_width = size
	shape.map_depth = size
	shape.map_data = data
	
	position.x += size/2 - 0.5
	position.z += size/2 - 0.5

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
