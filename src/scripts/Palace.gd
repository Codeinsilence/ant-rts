class_name Palace extends Unit

var spawn : Spawning
var palace_mesh: MeshInstance3D
# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	health = 5000
	if has_node("Spawning"): 
		spawn = $Spawning

	
	
	
func _physics_process(delta):
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_colony(col : Colony):
	await super(col)
	palace_mesh = get_node("Mesh")
	#if(palace_mesh == null): print("foo")
	
	if(colony.team == "player"):
		palace_mesh.set_surface_override_material(2, player_material)
		player_material.albedo_color = colony.team_color
		player_material.emission = colony.team_color * 1.5
		#player_material.emission_
		
	if(colony.team == "enemy"):
		palace_mesh.set_surface_override_material(2, enemy_material)
		enemy_material.albedo_color = colony.team_color
		enemy_material.emission = colony.team_color * 1.5
