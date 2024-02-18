extends CanvasLayer
class_name Player 

@export var Health : int
@export var Level : int = 1
@export var Money : int = 100 


@onready var level_text : RichTextLabel = %Level_Text as RichTextLabel
@onready var money_text : RichTextLabel = %Money_Text as RichTextLabel

var Health_bar : HealthBar

signal player_death()

func _ready():
	Health_bar = $HealthBar as HealthBar
	Health_bar.init(Health)
	
func _update():
	level_text.text = str(Level)
	money_text.text = str(Money)
	
func get_money():
	return Money
	
func add_money(value : int):
	Money += value
	
func level_complete():
	Level += 1
	
func get_level():
	return Level
	
func take_damage(damage : int):
	Health_bar.add_health(-damage)
	if Health_bar.get_current_health() <= 0:
		player_death.emit()
		
