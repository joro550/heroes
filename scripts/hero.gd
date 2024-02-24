extends CharacterBody2D
class_name Hero

signal hero_death()

@export var IsActive : bool
@export var Health : int 
@export var Damage: int
@export var Money : int

@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D
@onready var _avoidance := $Obstacle as NavigationObstacle2D

const Speed = 100.0
const AnimationToPlay = "walk"

var _health_bar : HealthBar

func _physics_process(delta: float):
	if IsActive:
		var dir = position.direction_to(nav_agent.get_next_path_position())
		var intended_velcocity = dir * Speed
		nav_agent.set_velocity(intended_velcocity)
		
func _nav_agent_velocity_computed(self_velocity):
	velocity = self_velocity
	move_and_slide()

func move_to_position(position : Vector2):
	global_position = position

func get_active():
	return IsActive
	
func set_active(level : int):
	IsActive = true
	_avoidance.avoidance_enabled = false
	
	_health_bar = $HealthBar as HealthBar
	if _health_bar:
		_health_bar.init(Health + level)
	nav_agent.velocity_computed.connect(_nav_agent_velocity_computed)
	$AnimationPlayer.play(AnimationToPlay)

func set_room(room:Room):
	move_to_position(room.get_entrance().global_position)
	nav_agent.target_position = room.get_exit().global_position
	
func set_initial_room(room:Room):
	nav_agent.target_position = room.get_exit().global_position

func set_target(target:Node2D):
	nav_agent.target_position = target.global_position
	nav_agent.target_reached.connect(_target_reached)

func get_damage():
	return Damage
	
func _target_reached():
	print("target reached")

func take_damage(damage : int):
	_health_bar.add_health(-damage)
	if _health_bar.get_current_health() <= 0:
		hero_death.emit()
		
