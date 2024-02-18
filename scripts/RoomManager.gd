extends Node2D
class_name RoomManager

@export var cost : int
@export var room_to_spawn : PackedScene

var been_bought : bool
var room : Room

var buy_button : Button
var left_button : Button
var right_button : Button
var upgrade_button : Button

func _ready():
	buy_button = %Buy_Button as Button
	left_button = %Left_Button as Button
	right_button = %Right_Button as Button
	upgrade_button = %Upgrade_Button as Button
	
	buy_button.pressed.connect(_on_button_pressed)
	
func show_button(visible : bool):
	self.button.visible = visible
	
func get_room() -> Room:
	return room

func _on_button_pressed():
	if not been_bought:
		room = room_to_spawn.instantiate() as Room
		
		add_child(room)
		room.init()
		
		been_bought = true
		$Bought.visible = true
		$Buy_Button.visible = false

