extends CharacterBody2D
class_name Hero

signal hero_death()

@export var Room : Room
@export var IsActive : bool
@export var Health : int 
@export var Damage: int

const Speed = 100.0
const AnimationToPlay = "walk"

var health_bar : HealthBar

func _physics_process(delta):
	if IsActive:
		var exit_position = Room.get_exit().global_position
		var target_position = (exit_position - global_position).normalized()
		velocity = target_position * Speed
		move_and_slide()

func move_to_position(position : Vector2):
	global_position = position

func get_active():
	return IsActive
	
func set_active(value: bool):
	IsActive = value
	if value:
		health_bar = $HealthBar as HealthBar
		health_bar.init(Health)
		
		$AnimationPlayer.play(AnimationToPlay)

func set_room(room:Room):
	move_to_position(room.get_entrance().global_position)
	Room = room
	
func set_initial_room(room:Room):
	Room = room

func get_damage():
	return Damage

func take_damage(damage : int):
	health_bar.add_health(-damage)
	if health_bar.get_current_health() <= 0:
		hero_death.emit()
		
