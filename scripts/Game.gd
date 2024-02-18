extends Node2D

@export var menu_scene : PackedScene
@export var game_screen: PackedScene
@export var game_over_scene: PackedScene

var added : PackedScene

func _ready():
	menu()
	
func menu():
	var m = menu_scene.instantiate()
	
	for n in get_children():
		n.queue_free()
	
	m.play_pressed.connect(play_game)
	add_child(m)

func play_game():
	var g = game_screen.instantiate()
	
	for n in get_children():
		n.queue_free()
		
	g.player_died.connect(game_over)
	add_child(g)
	
	
func game_over():
	var go = game_over_scene.instantiate()
	
	for n in get_children():
		n.queue_free()
		
	go.restart_pressed.connect(menu)
	add_child(go)
