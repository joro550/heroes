extends Node2D

@export var SafeRoom : Room
@export var BossRoom : Room
@export var RoomParent : Node2D
@export var HeroParent : Node2D
@export var PotentialHeros : Array[PackedScene]
@export var round_complete_prize:int = 100

var rng = RandomNumberGenerator.new()

var _current_hero : Hero
@onready var _player : Player = $Camera2D/Player

signal player_died()

func _ready():
	BossRoom.exit_reached.connect(_take_damage)
	SafeRoom.exit_reached.connect(_on_room_exit_reached)
	_player.player_death.connect(_handle_death)
	_setup_room_managers()
	
func _take_damage(room: Room):
	_player.take_damage(_current_hero.get_damage())
	_handle_heroes_turn_complete()
	
func _hero_died():
	_player.add_money(_current_hero.Money)
	_handle_heroes_turn_complete()
	
func _on_button_pressed():
	_setup_rooms()
	_generate_heroes()
	_pick_next_hero()
	%Play.visible = false

func _handle_death():
	player_died.emit()
	
func _on_room_exit_reached(room : Room):
	var next_room = room.get_next_room()
	
	# set the current hero to traverse the next room
	_current_hero.set_room(next_room)
	
func _room_damage_dealt(damage : int):
	_current_hero.take_damage(damage)
	
func _handle_heroes_turn_complete():
	HeroParent.remove_child(_current_hero)
	_current_hero.queue_free()
	if not _pick_next_hero():
		%Play.visible = true
		_player.add_money(round_complete_prize * _player.get_level())
	
func _generate_heroes():
	var heroes_to_spawn = rng.randi_range(1, _player.get_level() * 2)
	
	for i in heroes_to_spawn:
		var rand = rng.randi_range(0, PotentialHeros.size() - 1)
		var hero = PotentialHeros[rand].instantiate() as Hero
		hero.position.x = position.x + lerp(-50, 50, randf())
		hero.position.y = position.y + lerp(-50, 50, randf())
		HeroParent.add_child(hero)
	
		
func _pick_next_hero() -> bool:
	var children = HeroParent.get_children()
	
	if children.size() == 0:
		_player.level_complete()
		return false
		
	# pick the next hero to enter the dungeon
	var rand = rng.randi_range(0, children.size() - 1)
	
	_current_hero = children[rand] as Hero
	_current_hero.set_active(_player.get_level())
	_current_hero.set_initial_room(SafeRoom)
	_current_hero.hero_death.connect(_hero_died)
	return true
	
func _setup_rooms():
	var rooms : Array[Room] = []
	
	# loop through the children
	for node in RoomParent.get_children():
		var manager = node as RoomManager
		if not manager:
			continue
		
		var new_room = manager.get_room()
		if not new_room:
			continue
			
		rooms.append(new_room)
			
	# if no rooms are present then just jump straight to the boss room	
	# if rooms.size() == 0:
	#	SafeRoom.set_next_room(BossRoom)
	#	return
		
	var last_room = SafeRoom
	
	for room in rooms:
		last_room.set_next_room(room)
		
		# Setup the singal handlers 
		room.exit_reached.disconnect(_on_room_exit_reached)
		room.exit_reached.connect(_on_room_exit_reached)
		
		room.damage_dealt.disconnect(_room_damage_dealt)
		room.damage_dealt.connect(_room_damage_dealt)
		last_room = room
		
	last_room.set_next_room(BossRoom)
	
func _buy_room(manager : RoomManager):
	var new_room = manager.get_room()
	_player.add_money(-new_room.get_cost())
	manager.room_bought.disconnect(_buy_room)
	manager.room_upgraded.connect(_upgrade_room)
	
func _upgrade_room(cost:int):
	_player.add_money(-cost)
	
func _setup_room_managers():
	# loop through the children
	for node in RoomParent.get_children():
		var manager = node as RoomManager
		if not manager:
			continue
			
		manager.set_can_buy(false)
		manager.room_bought.connect(_buy_room)
		
func _process(delta):
	for node in RoomParent.get_children():
		var manager = node as RoomManager
		if not manager:
			continue
		
		var cost = manager.get_cost()
		var player_money = _player.get_money()
		
		if player_money >= cost:
			manager.set_can_buy(true)
		else:
			manager.set_can_buy(false)
			
		

