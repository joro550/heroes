extends Node2D

@onready var _room : Room = $Room1
@onready var _selected : Node2D = $Enemy

func _process(delta):
	var tilemap = _room.get_tilemap()
	var mouse_position = get_global_mouse_position()
	
	var tile_position = tilemap.local_to_map(mouse_position)
	var position = tilemap.map_to_local(tile_position)
	_selected.global_position = position
	
