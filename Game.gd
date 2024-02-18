extends Node2D

@export var menu : PackedScene
@export var game_screen: PackedScene

var added : PackedScene

func _ready():
	var m = menu.instantiate() 
	
	add_child(m)
	m.play_pressed.connect(play_game)

func play_game():
	var g = game_screen.instantiate()
	
	for n in get_children():
		n.queue_free()
	
	add_child(g)
