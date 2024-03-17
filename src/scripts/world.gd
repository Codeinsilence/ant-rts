extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	# For some reason I have to call this here and not in Colony.gd
	# or else it doesn't add the children to the scene properly
	$PlayerColony.spawn_starter_units()
	$EnemyColony.spawn_starter_units()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
