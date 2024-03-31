class_name Worker extends Unit

var move : Movement
var carry : Carrying
var step = 0.01
var t = 0.0
var moving = false
var animation_player: AnimationPlayer

var last_location: Vector3
var animation_threshold_dist = 0.01 

# Called when the node enters the scene tree for the first time.
func _ready():
	health = 100.0;
	location = self.global_position;
	move = $Movement
	carry = $Carrying
	$SelectionRing.hide()
	super._ready()
	
	# Animation controls
	last_location = location
	animation_player = get_node("WorkerMeshAnimated/AnimationPlayer")

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
