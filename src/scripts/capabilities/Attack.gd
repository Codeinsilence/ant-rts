extends Node

class_name Attack

var attack_target : Unit
var patrol_target : Vector3
var in_attack_mode : bool = false
var in_patrol_mode : bool = false
var target_look_cooldown : float = 0.0
var can_attack : bool = true

@export var attack_distance : float
@export var aggro_distance : float = 10.0
@export var rate_of_attack : float
@export var damage : float

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta):
	if in_patrol_mode:
		target_look_cooldown -= delta
		if target_look_cooldown <= 0:
			look_for_target()
			target_look_cooldown = 1.0
		if _check_valid_target():
			_update_attack_target_position()
			if can_attack: _deal_damage()
		else:
			set_patrol_target(patrol_target)
	elif in_attack_mode:
		if _check_valid_target():
			_update_attack_target_position();
			if can_attack:
				_deal_damage()
		else:
			get_parent().cur_action = "idle"

func _set_attack_target(unit: Unit) -> bool:
	if not unit is Unit:
		print("Unit is not combatable.")
		return false
	attack_target = unit;
	get_parent().get_node("Movement").set_destination(unit.position)
	return true
	
func set_patrol_target(pos:Vector3) -> bool:
	if pos == null: return false
	patrol_target = pos
	reset_modes()
	in_patrol_mode = true
	get_parent().get_node("Movement").set_destination(pos)
	get_parent().cur_action = "patrolling"
	return true
	
func look_for_target():
	var parent : Unit = get_parent()
	var enemy_team : String = ""
	if get_parent().colony.group_name == "player": enemy_team = "enemy"
	else: enemy_team = "player"
	
	var closest_enemy : Unit = null
	for unit in get_tree().get_nodes_in_group(enemy_team):
		if not unit is Unit: continue
		if closest_enemy == null:
			closest_enemy = unit
			continue
		if parent.position.distance_to(unit.position) < parent.position.distance_to(closest_enemy.position):
			closest_enemy = unit
	
	if closest_enemy != null and parent.position.distance_to(closest_enemy.position) < aggro_distance:
		_set_attack_target(closest_enemy)

func _update_attack_target_position():
	if _check_valid_target():
		get_parent().get_node("Movement").set_destination(attack_target.position)
		
func _set_attack_mode(mode : bool):
	in_attack_mode = mode
	
func _set_patrol_mode(mode : bool):
	in_patrol_mode = mode
	
func reset_modes():
	in_attack_mode = false
	in_patrol_mode = false

func _deal_damage():
	var parent = get_parent()
	if parent.position.distance_to(attack_target.global_position) <= (attack_target.radius + attack_distance):
		print("attacked")
		can_attack = false
		attack_target._take_damage(damage);
		await get_tree().create_timer(rate_of_attack).timeout
		can_attack= true

func _check_valid_target(): #checking for freed/invalid instance
	if !is_instance_valid(attack_target):
		attack_target = null
		return false
	return true
