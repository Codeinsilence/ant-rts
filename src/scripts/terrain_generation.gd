extends MeshInstance3D

var mdt = MeshDataTool.new()
var heightmap = null
var size = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	# Create array of arrays
	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)
	
	var verts = PackedVector3Array()
	var norms = PackedVector3Array()
	var uvs = PackedVector2Array()
	var indices = PackedInt32Array()
	
	# Create height map
	var height_png = load("res://assets/terrain_heightmap_smoothed.png")
	var png_size = height_png.get_width()
	size = png_size
	var height_scale_factor = 100.0
	#var num_waves_i = 3 
	#var height_waves_i = size / 64
	#var num_waves_j = 9
	#var height_waves_j = size / 64
	heightmap = PackedFloat32Array()
	for i in range(size):
		for j in range(size):
			var h = height_png.get_pixel(i, j).r * height_scale_factor
			#h += sin((PI * i * num_waves_i) / size) * height_waves_i
			#h += sin((PI * j * num_waves_j) / size) * height_waves_j
			verts.append(Vector3(j, h, i))
			# Set up heightmap for later use
			# heightmap.push_back(h)
			# Zero normals to start, will fix them later
			norms.append(Vector3(0.0, 0.0, 0.0))
			uvs.append(Vector2(float(i) / size, float(j) / size))
			
	# Run multiple smoothing passes
	var num_passes = 5
	for n in range(num_passes):
		# Smoothing pass to reduce blocky/layered look
		for i in range(1, size-1):
			for j in range(1, size-1):
				# Average height of this point with the 4 adjacent points
				var h_avg = verts[i * size + j].y \
						  + verts[(i-1) * size + j].y \
						  + verts[(i+1) * size + j].y \
						  + verts[i * size + (j-1)].y \
						  + verts[i * size + (j+1)].y;
				h_avg = h_avg / 5.0
				verts[i * size + j].y = h_avg
	
	# Generate height map to pass to collision shape
	for i in range(size):
		for j in range(size):
			heightmap.push_back(verts[i * size + j].y)
	
	
	# Create indices array (defines triangle faces)
	# Triangles wind in clockwise order
	# Beware this section is easy to break
	for i in range(size):
		for j in range(size):
			if i > 0 and j > 0:
				# Find indices of corners
				# (i-1,j-1) ---- (i-1, j)
				#     |      X      |
				#  (i,j-1) ------ (i,j)
				var this_ind = i * size + j
				var left_ind = i * size + (j-1)
				var top_ind =  (i-1) * size + j
				var top_left_ind = (i-1) * size + (j-1)
				# Add triangle LEFT-TOPLEFT-TOP
				indices.append(left_ind)
				indices.append(top_left_ind)
				indices.append(top_ind)
				# Add triangle TOP-THIS-LEFT
				indices.append(top_ind)
				indices.append(this_ind)
				indices.append(left_ind)
	
	# Add data to array of arrays
	arrays[Mesh.ARRAY_VERTEX] = verts
	arrays[Mesh.ARRAY_NORMAL] = norms
	arrays[Mesh.ARRAY_TEX_UV] = uvs
	arrays[Mesh.ARRAY_INDEX] = indices
	
	# Create mesh
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	
	# Set normals
	# This code mostly from
	# https://docs.godotengine.org/en/stable/tutorials/3d/procedural_geometry/meshdatatool.html
	mdt.create_from_surface(mesh, 0)
	for i in range(mdt.get_face_count()):
		# Get index in vertex array
		var a = mdt.get_face_vertex(i, 0)
		var b = mdt.get_face_vertex(i, 1)
		var c = mdt.get_face_vertex(i, 2)
		# Get vertex position using vertex index.
		var ap = mdt.get_vertex(a)
		var bp = mdt.get_vertex(b)
		var cp = mdt.get_vertex(c)
		# Calculate face normal.
		var n = (bp - cp).cross(ap - bp).normalized()
		# Add face normal to current vertex normal.
		# This will not result in perfect normals, but it will be close.
		mdt.set_vertex_normal(a, n + mdt.get_vertex_normal(a))
		mdt.set_vertex_normal(b, n + mdt.get_vertex_normal(b))
		mdt.set_vertex_normal(c, n + mdt.get_vertex_normal(c))
		
	# Run through vertices one last time to normalize normals and
	# set color to normal.
	for i in range(mdt.get_vertex_count()):
		var v = mdt.get_vertex_normal(i).normalized()
		mdt.set_vertex_normal(i, v)
		mdt.set_vertex_color(i, Color(v.x, v.y, v.z))
	
	mesh.clear_surfaces()
	mdt.commit_to_surface(mesh)
	
	ResourceSaver.save(mesh, "res://assets/models/terrain.tres")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
