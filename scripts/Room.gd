extends Node2D
class_name Room

@export var Exit : Area2D
@export var Entrance : Area2D

signal _exit_reached(room:Room)

var _nextRoom : Room

func get_exit() -> Node2D:
	return Exit
	
func get_entrance() -> Node2D:
	return Entrance

func set_next_room(room: Room):
	_nextRoom = room
	
func get_next_room() -> Room:
	return _nextRoom

func _on_area_2d_area_entered(area):
	print("exit has been hit")
	_exit_reached.emit(self)
	
