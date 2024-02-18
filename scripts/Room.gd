extends Node2D
class_name Room

@export var Exit : Area2D
@export var Entrance : Area2D
@export var damage :int = 2
@export var level : int = 1

func _ready():
	var exit = $Exit as Area2D
	exit.body_entered.connect(_on_exit_body_entered)
	
func init():
	var damage = $Damage as Area2D

	print("setting up room")
	if damage:
		damage.body_entered.connect(player_hit_damage)

signal exit_reached(room:Room)
signal damage_dealt(damage: int)

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
	
func player_hit_damage(body):
	print("hit damage layer")
	damage_dealt.emit(damage * level)
