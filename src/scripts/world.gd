extends Node3D

var done_first_frame_setup = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	# Had to move this here to stop errors with navigation before NavMap exists
	if not done_first_frame_setup:
		$PlayerColony.spawn_starter_units()
		$EnemyColony.spawn_starter_units()
		done_first_frame_setup = true
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
