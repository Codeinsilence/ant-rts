class_name Worker extends Unit

var move : Movement
var step = 0.01
var t = 0.0
var moving = false

# Called when the node enters the scene tree for the first time.
func _ready():
	health = 100.0;
	location = self.global_position;
	move = $Movement
	$SelectionRing.hide()
	
	super._ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_destination(target:Vector3):
	$Movement._set_destination(location, target)

func set_moving(moving_bool):
	moving = moving_bool
	
func set_selectionring_color(col : Color):
	$SelectionRing.mesh.material.albedo_color = col

func add_to_selected_units():
	self.add_to_group("selected_units");
	$SelectionRing.show()

func remove_from_selected_units():
	self.remove_from_group("selected_units");
	$SelectionRing.hide()

# Code taken from A3
#func _move(delta):
	#var pt
	#var tg
	#
	#if moving:
		#t += step
		#var val = move._move(t)
		#if val == []:
			#moving = false;
			#t = 0;
			#return
		#pt = val[0]
		#tg = val[1]
		#t += step
		#self.transform = Transform3D().translated(pt) * \
						 #Transform3D().looking_at(tg, Vector3.UP) *\
						 #Transform3D().rotated(Vector3.UP, -PI/2.0) *\
						 #Transform3D().scaled(scale)

