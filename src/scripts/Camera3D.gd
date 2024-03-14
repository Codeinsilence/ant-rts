extends Camera3D

var PIVOT: Node3D;

@export var speed: float = 4.0;
@export var max_size = 100;
@export var min_size = 10;

var rot_quat: Quaternion;
var mouse = Vector2();
var ray_length = 1000

func _ready():
	PIVOT = get_parent();

func _process(delta):
	rot_quat = Quaternion(0,sin(rotation.y/2),0,cos(rotation.y/2)).normalized();
	if(Input.is_action_pressed("up_arrow")):
		PIVOT.position +=  rot_quat * Vector3(0,0,delta*-speed);
	if(Input.is_action_pressed("down_arrow")):
		PIVOT.position +=  rot_quat * Vector3(0,0,delta*speed);
	if(Input.is_action_pressed("left_arrow")):
		PIVOT.position +=  rot_quat * Vector3(delta*-speed,0,0);
	if(Input.is_action_pressed("right_arrow")):
		PIVOT.position +=  rot_quat * Vector3(delta*speed,0,0);
	if(Input.is_action_just_released("zoom_in")):
		size = max(size - 5, min_size);
	if(Input.is_action_just_released("zoom_out")):
		size = min(size + 5, max_size)
	
	# Mouse selection handling
	if(Input.is_action_just_pressed("left_click")):
		mouse = get_viewport().get_mouse_position();
		left_selection();
	if(Input.is_action_just_pressed("right_click")):
		mouse = get_viewport().get_mouse_position();
		right_selection();

func mouse_selection():
	var worldspace = get_world_3d().direct_space_state;
	var start = project_ray_origin(mouse);
	var end = project_position(mouse, ray_length);
	var result = worldspace.intersect_ray(PhysicsRayQueryParameters3D.create(start, end));
	return result;
		
func left_selection():
	var result = mouse_selection()
	#print(result)
	if(result and result.collider.has_method("add_to_selected_units")):
		result.collider.add_to_selected_units();
		print("Added a unit to selected units");
	else:
		if(get_tree().has_group("selected_units")):
			get_tree().call_group("selected_units", "remove_from_selected_units");
			print("Emptied out selected units");

func right_selection():
	var result = mouse_selection()
	#print(result)
	#note: ant only moves if result has valid position
	if(result and get_tree().has_group("selected_units")):
		get_tree().call_group("selected_units", "set_destination", result.position);
		get_tree().call_group("selected_units", "set_moving", true);
		
	
