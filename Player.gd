extends CanvasLayer
class_name Player 

@export var Health : int
var Health_bar : HealthBar

signal player_death()

func _ready():
	Health_bar = $HealthBar as HealthBar
	Health_bar.init(Health)

func take_damage(damage : int):
	Health_bar.add_health(-damage)
	if Health_bar.get_current_health() <= 0:
		player_death.emit()
