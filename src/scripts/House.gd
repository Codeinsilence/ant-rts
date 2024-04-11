class_name House extends Unit

@export var capacity: int = 10
var radius: float = 3.0

var house_mesh: MeshInstance3D

# Called when the node enters the scene tree for the first time.
func _ready():
	
	super._ready()
	health = 300
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_capacity():
	return capacity;

func _take_damage(amt: float):
	decrease_health(amt)
	if health <= 0:
		colony.single_house_destroyed()
		queue_free()

func set_colony(col : Colony):
	await super(col)
	house_mesh = get_node("MeshInstance3D")
	
	if(colony.team == "player"):
		house_mesh.set_surface_override_material(1,player_material) 
		

	if(colony.team == "enemy"):
		house_mesh.set_surface_override_material(1,enemy_material) 
