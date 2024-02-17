extends CharacterBody2D
class_name Hero

signal hero_death()

@export var Room : Room
@export var IsActive : bool
@export var Health : int

const Speed = 100.0
const AnimationToPlay = "walk"

func _on_ready():
	$AnimationPlayer.play(AnimationToPlay)

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

func set_room(room:Room):
	Room = room

func take_damage(damage : int):
	Health -= damage
	if Health <= 0:
		hero_death.emit()
		
