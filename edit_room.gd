extends Node2D

@onready var _room : Room = $Room1
@onready var _selected : Node2D = $Enemy
@onready var _done_button: Button = $Button
@onready var _thing : Node2D = $Thing

func _ready():
	_done_button.pressed.connect(_done)

func _process(delta):
	var tilemap = _room.get_tilemap()
	var mouse_position = get_global_mouse_position()
	
	var tile_position = tilemap.local_to_map(mouse_position)
	var position = tilemap.map_to_local(tile_position)
	_selected.global_position = position
	
	if Input.is_action_just_released("mouse_down"):
		var child = _selected.duplicate()
		child.position = _room.to_local(child.global_position)
		_room.add_child(child)
	
func _done():
	remove_child(_room)
	_thing.add_child(_room)
	

	
