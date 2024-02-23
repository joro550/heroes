extends CanvasLayer
class_name Player 

@export var Health : int
@export var Level : int = 1
@export var Money : int = 100 

@onready var _level_text : RichTextLabel = %Level_Text as RichTextLabel
@onready var _money_text : RichTextLabel = %Money_Text as RichTextLabel

var _health_bar : HealthBar

signal player_death()

func _ready():
	_health_bar = $HealthBar as HealthBar
	_health_bar.init(Health)
	
func _process(delta):
	_level_text.text = str(Level)
	_money_text.text = str(Money)
	
func get_money():
	return Money
	
func add_money(value : int):
	Money += value
	
func level_complete():
	Level += 1
	
func get_level():
	return Level
	
func take_damage(damage : int):
	_health_bar.add_health(-damage)
	if _health_bar.get_current_health() <= 0:
		player_death.emit()
		
