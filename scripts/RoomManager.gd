extends Node2D
class_name RoomManager

@export var cost : int
@export var room_to_spawn : PackedScene

signal room_bought(manager : RoomManager)
signal room_upgraded(cost: int)

var been_bought : bool
var can_buy : bool
var room : Room

var buy_button : Button
var left_button : Button
var right_button : Button
var upgrade_button : Button
var level_text:RichTextLabel
var cost_text: RichTextLabel

func _ready():
	buy_button = %Buy_Button as Button
	left_button = %Left_Button as Button
	right_button = %Right_Button as Button
	upgrade_button = %Upgrade_Button as Button
	level_text = %Level_Text
	cost_text = %Cost_Text
	
	buy_button.pressed.connect(_on_button_pressed)
	upgrade_button.pressed.connect(_on_upgraded_pressed)

func _process(delta):
	if not been_bought and can_buy:
		buy_button.visible = true
	elif not been_bought and not can_buy:
		buy_button.visible = false
	elif been_bought and can_buy:
		$Bought.visible = true
	else:
		$Bought.visible = false
		
	if been_bought:
		level_text.text = "Level: " + str(room.get_level())
		cost_text.text = "Cost: " + str(get_cost())
		
	
func get_room() -> Room:
	return room
	
func set_can_buy(value : bool):
	can_buy = value
	
func get_cost() -> int:
	if not been_bought:
		return cost
	else:
		return cost * room.get_level()

func _on_button_pressed():
	if not been_bought:
		room = room_to_spawn.instantiate() as Room
		
		add_child(room)
		room.init()
		
		been_bought = true
		can_buy = false
		room_bought.emit(self)
		$Bought.visible = true
		$Buy_Button.visible = false

func _on_upgraded_pressed():
	room_upgraded.emit(get_cost())
	room.add_level(1)
		

