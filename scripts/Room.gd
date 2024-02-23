extends Node2D
class_name Room

@export var _exit : Node2D
@export var Entrance : Area2D
@export var damage :int = 2
@export var level : int = 1
@export var cost: int = 100

var _next_room : Room

signal exit_reached(room:Room)
signal damage_dealt(damage: int)

func _ready():
	var exit_door = $Exit
	exit_door.body_entered.connect(_on_exit_body_entered)
	
func init():
	var damage = $Damage as Area2D
	
	if damage:
		damage.body_entered.connect(player_hit_damage)

func get_exit() -> Node2D:
	return _exit
	
func get_entrance() -> Node2D:
	return Entrance

func set_next_room(room: Room):
	_next_room = room
	
func get_next_room() -> Room:
	return _next_room
	
func _on_exit_body_entered(body: Node2D):
	exit_reached.emit(self)
	
func player_hit_damage(body):
	damage_dealt.emit(damage + level)
	
func get_level() -> int:
	return level

func add_level(value:int):
	level += value
