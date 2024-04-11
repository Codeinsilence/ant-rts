extends Node

class_name Building

@export var house:PackedScene
@onready var house_scene = preload("res://scenes/house.tscn");

var camera: Camera3D
var mouse_pos: Vector2
var _object_dragging: Node3D
var _dragging: bool = false
var _distance_from_palace: float = 50.0

# Called when the node enters the scene tree for the first time.
func _ready():
	_object_dragging = house.instantiate()
	_object_dragging.position = Vector3(0, 0, 0)
	add_child(_object_dragging)
	_object_dragging.visible = false
	camera = get_viewport().get_camera_3d()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_released("B"):
		if _dragging:
			_deselect()
		else:
			_dragging = true
			camera.building_mode = true
	if Input.is_action_just_pressed("right_click"):
		_deselect()
		
	
func _physics_process(delta):
	drag_and_drop()

func drag_and_drop():
	if _dragging:
		var worldspace = _object_dragging.get_world_3d().direct_space_state
		mouse_pos = get_viewport().get_mouse_position();
		var start = camera.project_ray_origin(mouse_pos);
		var end = camera.project_position(mouse_pos, 1000);
		var result = worldspace.intersect_ray(PhysicsRayQueryParameters3D.create(start, end));
		
		if result:
			_object_dragging.visible = true
			_object_dragging.global_position = result.position
			_color_checking(_object_dragging)
			if Input.is_action_just_released("left_click"):
				_checking_area(_object_dragging)
		else:
			_object_dragging.visible = false

func _color_checking(obj: Node3D):
	var colony = get_parent()
	var available_food = false
	var good_distance = false
	var house_cost = colony.cost_house
	#resource checking, red if insufficient resources and too far
	if colony.food >= house_cost["food"] and colony.protein >= house_cost["protein"] and colony.foliage >= house_cost["foliage"]:
		available_food = true
	
	if obj.position.distance_to(colony.position) <= _distance_from_palace:
		good_distance = true
		
	var color = Vector4(1, 0, 0, 1)
	if obj.has_overlapping_bodies():
		var bodies = obj.get_overlapping_bodies()
		if bodies.size() == 1 and bodies[0].name == "TerrainBody" and available_food and good_distance:
			color = Vector4(0, 1, 0, 1);
	var shader0 = obj.get_child(0).get_surface_override_material(0)
	var shader1 = obj.get_child(0).get_surface_override_material(1)
	shader0.set_shader_parameter("color", color)
	shader1.set_shader_parameter("color", color)

func _checking_area(obj: Node3D):
	var colony = get_parent()
	if obj.has_overlapping_bodies():
		var bodies = obj.get_overlapping_bodies()
		if bodies.size() == 1 and bodies[0].name == "TerrainBody":
			if obj.position.distance_to(colony.position) <= _distance_from_palace:
				_check_resources(_object_dragging.position);
			else:
				print("Too far from palace, cannot build here.")
				return
		else:
			print("Cannot build here.")
			return
			
func _check_resources(pos: Vector3):
	var colony = get_parent()
	if colony.pay_all(colony.cost_house):
		_drop_building(pos, colony)
	else:
		print("Insufficient resources.")
		return
	
func _drop_building(pos: Vector3, colony: Colony):
	var terrain = $"../../NavRegion/TerrainBody"
	var instance = house_scene.instantiate()
	instance.position = pos
	instance.position.y = terrain.height_at(instance.position) + 0.1 
	instance.set_colony(colony)
	add_child(instance)
	colony.houses += 1
	_deselect()

func _deselect():
	_dragging = false
	_object_dragging.position = Vector3(0, 0, 0)
	_object_dragging.visible = false
	camera.building_mode = false
	return
