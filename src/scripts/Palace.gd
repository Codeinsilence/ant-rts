class_name Palace extends Unit

var spawn : Spawning

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
