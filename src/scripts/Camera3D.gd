extends Camera3D

# Preload cursor images and create timer for cursor transitions
@onready var cursor_fb_timer := Timer.new()
@onready var cursor_lifespan = 0.15
var cursor_default = preload("res://assets/cursors/cursor-pointer-1.png")
var cursor_select = preload("res://assets/cursors/cursor-pointer-18.png")
var cursor_harvest = preload("res://assets/cursors/cursor-target-6.png")
var cursor_move = preload("res://assets/cursors/cursor-target-9.png")

var PIVOT: Node3D;

@export var speed: float = 4.0;
@export var max_size = 100;
@export var min_size = 10;

var rot_quat: Quaternion;
var mouse_pos = Vector2();
var ray_length = 1000

var mouse_down_pos : Vector2;
var mouse_is_down : bool

func _ready():
	PIVOT = get_parent();
	mouse_is_down = false
	
	cursor_fb_timer.one_shot = true
	cursor_fb_timer.connect("timeout", _reset_cursor)
	add_child(cursor_fb_timer)
	
# Resets the cursor to the default image
func _reset_cursor():
	DisplayServer.cursor_set_custom_image(cursor_default)

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
	mouse_pos = get_viewport().get_mouse_position();
	if(Input.is_action_just_pressed("left_click")):
		mouse_down_pos = mouse_pos
		mouse_is_down = true
		$SelectionBox.show()
	if(Input.is_action_just_released("left_click")):
		mouse_is_down = false
		$SelectionBox.hide()
		if (mouse_pos - mouse_down_pos).length() > $SelectionBox.min_size:
			box_selection(mouse_down_pos, mouse_pos)
		else:
			left_selection();
	if(Input.is_action_just_pressed("right_click")):
		right_selection();
	
	#Update selection box visuals
	if mouse_is_down:
		$SelectionBox.update_positions(mouse_down_pos, mouse_pos)
		

func mouse_selection():
	var worldspace = get_world_3d().direct_space_state;
	var start = project_ray_origin(mouse_pos);
	var end = project_position(mouse_pos, ray_length);
	var result = worldspace.intersect_ray(PhysicsRayQueryParameters3D.create(start, end));	
	return result;

## Single unit selection (left click)
func left_selection():
	var result = mouse_selection()
	
	# If not holding shift, clear out selected group first
	if not Input.is_action_pressed("shift"):
		for member in get_tree().get_nodes_in_group("selected_units"):
			member.remove_from_selected_units()
	if(result and result.collider.has_method("add_to_selected_units")):
		DisplayServer.cursor_set_custom_image(cursor_select)
		cursor_fb_timer.start(cursor_lifespan)
		result.collider.add_to_selected_units();

## Issues commands on selected group
func right_selection():
	var result = mouse_selection()
	if not result: return
	if not get_tree().has_group("selected_units"): return
	
	var special_command_issued = false
	# Collect resource command
	if result.collider is Harvestable:
		for member in get_tree().get_nodes_in_group("selected_units"):
			if member.is_in_group("player") && member.has_node("Carrying"):
				member.get_node("Carrying").set_resource_target(result.collider)
				member.get_node("Carrying").move_to_resource()
				member.set_moving(true)
				special_command_issued = true
				member.cur_action = "harvesting"
				# update cursor
				DisplayServer.cursor_set_custom_image(cursor_harvest)
				cursor_fb_timer.start(cursor_lifespan)
	# Resource drop off command
	elif result.collider.has_node("Spawning") and result.collider.is_in_group("player"):
		
		for member in get_tree().get_nodes_in_group("selected_units"):
			if member.has_node("Carrying"):
				if member.carry.inventory_space_remaining() < member.carry.inventory_size:
					member.carry.set_dropoff_target(result.collider)
					member.carry.move_to_dropoff()
					special_command_issued = true
					member.cur_action = "Dropping off"
	
	elif result.collider.has_node("Movement") and result.collider.is_in_group("enemy"):
		for member in get_tree().get_nodes_in_group("selected_units"):
			if member.has_node("Attack"):
				member.attack._set_attack_target(result.collider)
				member.attack._set_attack_mode(true)
				special_command_issued = true
				member.cur_action = "attacking"
	
	# Move to location
	if special_command_issued : return
	for member in get_tree().get_nodes_in_group("selected_units"):
			if member.is_in_group("player") && member.has_node("Movement"):
				member.set_destination(result.position)
				member.set_moving(true)
				if member.has_node("Attack"):
					member.attack._set_attack_mode(false)
				member.cur_action = "moving"
				# cursor update
				DisplayServer.cursor_set_custom_image(cursor_move)
				cursor_fb_timer.start(cursor_lifespan)

## Drawing a selection box
func box_selection(corner1, corner2):
	# Define the box
	var top_left_corner = Vector2(min(corner1.x, corner2.x), min(corner1.y, corner2.y))
	var dimensions = Vector2(abs(corner1.x - corner2.x), abs(corner1.y - corner2.y))
	var box = Rect2(top_left_corner, dimensions)
	# Check what's in the box
	for unit in get_tree().get_nodes_in_group("selectable"):
		if box.has_point(unproject_position(unit.global_transform.origin)):
			unit.add_to_selected_units()
		else:
			if not Input.is_action_pressed("shift"):
				unit.remove_from_selected_units()
	
	
