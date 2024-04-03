class_name Worker extends Unit

var move : Movement
var carry : Carrying
var attack : Attack
var step = 0.01
var t = 0.0
var moving = false
var animation_player: AnimationPlayer

var last_location: Vector3
var animation_threshold_dist = 0.01 

var ant_mesh: MeshInstance3D
@onready var ant_texture = preload("res://assets/models/ant.jpg")

# Called when the node enters the scene tree for the first time.
func _ready():
	health = 100.0;
	location = self.global_position;
	move = $Movement
	carry = $Carrying
	attack = $Attack
	$SelectionRing.hide()
	super._ready()
	
	# Animation controls
	last_location = location
	animation_player = get_node("WorkerMeshAnimated/AnimationPlayer")
	
	# stupid texture bug fix
	ant_mesh = get_node("WorkerMeshAnimated/RootNode/\r\nant /skeleton /Skeleton3D/\r\nant _4")
	var ant_mat := ant_mesh.mesh.surface_get_material(0)
	ant_mat.albedo_texture = ant_texture
	#print()
	#ant_mesh.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(moving == true):
		animation_player.current_animation = "C4D Animation Take"
	if(moving == false):
		animation_player.current_animation = ""


func _physics_process(delta):
	location = self.global_position
	
	if location.distance_to(last_location) < animation_threshold_dist:
		moving = false
	else:
		moving = true
	
	last_location = location

func set_destination(target:Vector3):
	$Movement.set_destination(target)

func set_moving(moving_bool):
	moving = moving_bool

func _take_damage(amt: float):
	decrease_health(amt)
	if health <= 0:
		colony._single_ant_killed()
		queue_free()
