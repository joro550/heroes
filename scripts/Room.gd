extends Node2D
class_name Room

@export var _exit : Node2D
@export var _entrance : Area2D
@export var _damage :int = 2
@export var _level : int = 1
@export var _cost: int = 100

@onready var _tile_map : TileMap = $TileMap

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
	return _entrance

func set_next_room(room: Room):
	_next_room = room
	
func get_next_room() -> Room:
	return _next_room
	
func _on_exit_body_entered(body: Node2D):
	exit_reached.emit(self)
	
func player_hit_damage(body):
	damage_dealt.emit(_damage + _level)
	
func get_level() -> int:
	return _level

func add_level(value:int):
	_level += value
	
func get_cost() -> int:
	return _cost
	
func get_tilemap() -> TileMap:
	return _tile_map
