extends Node2D

@export var _scene : PackedScene 
var dictionary : Dictionary = {}

@onready var _camera : Camera2D = $Camera2D

func _ready():
	for n in 5:
		var vector = Vector2(n, 0)
		
		var to_add = _scene.instantiate() as Test
		add_child(to_add)
		
		var height = to_add.get_height()
		var width = to_add.get_width()
		var position = n * width
		
		to_add.position = Vector2(position, 0)
		
		
func _process(delta):
	var zoom = 1 * delta
	
	if Input.is_action_pressed("move_up"):
		print("in")
		_camera.zoom.x += zoom
		_camera.zoom.y += zoom
	elif Input.is_action_pressed("move_down"):
		print("out")
		_camera.zoom.x -= zoom
		_camera.zoom.y -= zoom
		
		
		
		




