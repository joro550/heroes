extends Camera2D

class_name Camera

@export var _max_zoom : int
@export var _min_zoom : int
@export var _speed : int = 100
@export var _clamp_x_min : Node2D
@export var _clamp_x_max : Node2D

func _process(delta):
	var position = global_position
	
	
	if Input.is_action_pressed("move_right"):
		var x  = position.x + (_speed * delta)
		var min_x = _clamp_x_min.position.x
		var max_x = _clamp_x_max.position.x
		position.x = clamp(x, min_x, max_x)
	elif Input.is_action_pressed("move_left"):
		var x  = position.x - (_speed * delta)
		var min_x = _clamp_x_min.position.x
		var max_x = _clamp_x_max.position.x
		position.x = clamp(x, min_x, max_x)
	elif  Input.is_action_pressed("move_down"):
		var to_zoom = clamp((_speed * delta), _min_zoom, _max_zoom)
		zoom -= Vector2(to_zoom, to_zoom)
		
	elif  Input.is_action_pressed("move_up"):
		var to_zoom = clamp((_speed * delta), _min_zoom, _max_zoom)
		zoom += Vector2(to_zoom, to_zoom)
		
	
	global_position = position
	
