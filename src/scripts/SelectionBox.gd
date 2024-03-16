extends Control
# Based on the tutorial in this video: https://www.youtube.com/watch?v=JFQXI3to0b4
var cam : Camera3D;
@export var box_color:Color;
@export var min_size = 3.0;
@export var line_width = 1.0;

var start_pos: Vector2 = Vector2()
var end_pos: Vector2 = Vector2()

# Should be called by Camera3D's _process()
func update_positions(start, end):
	start_pos = start
	end_pos = end

# Called when the node enters the scene tree for the first time.
func _ready():
	cam = get_parent()
	hide() 
	pass # Replace with function body.
	
func _draw():
	# Abort if below min_size
	if (start_pos - end_pos).length() < min_size:
		pass
	# Define other 2 corners
	var corner3 = Vector2(end_pos.x, start_pos.y)
	var corner4 = Vector2(start_pos.x, end_pos.y)
	# Draw 4 lines
	draw_line(start_pos, corner3, box_color, line_width)
	draw_line(start_pos, corner4, box_color, line_width)
	draw_line(end_pos, corner3, box_color, line_width)
	draw_line(end_pos, corner4, box_color, line_width)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	queue_redraw()
