extends Node2D
class_name Test

@onready var _area : Area2D = $Area2D
@onready var _collision_shape : CollisionShape2D = $Area2D/CollisionShape2D

func _ready():
	_area.mouse_entered.connect(_mouse_entered)

func _mouse_entered():
	print("mouse_entered")
	
func get_height():
	return _collision_shape.shape.size.y

func get_width():
	return _collision_shape.shape.size.x
