extends TextureProgressBar
class_name HealthBar

var maxHealth: int = 3
var currentHealth : int = 3

func _process(delta):
	value = currentHealth
	
func init(value : int):
	maxHealth = value
	currentHealth = value
	
	min_value = 0
	max_value = maxHealth
	value = currentHealth
	
func get_current_health():
	return currentHealth
	
func add_health(value : int):
	currentHealth += value
