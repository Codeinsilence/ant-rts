class_name Worker extends Unit

var move : Movement
var carry : Carrying
var step = 0.01
var t = 0.0
var moving = false

# Called when the node enters the scene tree for the first time.
func _ready():
	health = 100.0;
	location = self.global_position;
	move = $Movement
	carry = $Carrying
	$SelectionRing.hide()
	
	super._ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_destination(target:Vector3):
	$Movement._set_destination(location, target)

func set_moving(moving_bool):
	moving = moving_bool
	


func collect_resource(resource):
	set_destination(resource.global_position);
	$Carrying._set_resource_target(resource)
