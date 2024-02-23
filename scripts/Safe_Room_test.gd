extends Node2D

@export var target:Node2D

@onready var _hero : Hero = $hero
@onready var _safe_room : Room = $Room




func _on_button_pressed():
	_hero.set_active(1)
	_hero.set_initial_room(_safe_room)
	_safe_room.exit_reached.connect(dothing)

func dothing(room: Room):
	print("exit reached")


func _on_area_2d_body_entered(body):
	print("hello")
