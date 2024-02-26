extends Camera3D

var PIVOT: Node3D;

var speed: float = 4.0;

var rot_quat: Quaternion;

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
