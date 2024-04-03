extends Node

class_name Attack

var attack_target : Unit
var in_attack_mode : bool = false
var can_attack : bool = true

@export var attack_distance : float
@export var rate_of_attack : float
@export var damage : float

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta):
	if in_attack_mode:
		if _check_valid_target():
			_update_attack_target_position();
			if can_attack:
				_deal_damage()
	pass

func _set_attack_target(unit: Unit) -> bool:
	if not unit is Worker:
		print("Unit is not combatable.")
		return false
	attack_target = unit;
	get_parent().get_node("Movement").set_destination(unit.position)
	return true
	
func _update_attack_target_position():
	if _check_valid_target():
		get_parent().get_node("Movement").set_destination(attack_target.position)
		
func _set_attack_mode(mode : bool):
	in_attack_mode = mode

func _deal_damage():
	var parent = get_parent()
	if parent.position.distance_to(attack_target.global_position) <= attack_distance:
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
