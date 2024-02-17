extends Node2D
class_name Room

@export var Exit : Area2D
@export var Entrance : Area2D

func _ready():
	var exit = $Exit as Area2D
	exit.body_entered.connect(_on_exit_body_entered)

signal exit_reached(room:Room)

var _nextRoom : Room

func get_exit() -> Node2D:
	return Exit
	
func get_entrance() -> Node2D:
	return Entrance

func set_next_room(room: Room):
	_nextRoom = room
	
func get_next_room() -> Room:
	return _nextRoom
	
func _on_exit_body_entered(body):
	exit_reached.emit(self)
