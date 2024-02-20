extends Node2D
@export var SafeRoom : Room
@export var BossRoom : Room
@export var RoomParent : Node2D
@export var HeroParent : Node2D
@export var PotentialHeros : Array[PackedScene]
@export var round_complete_prize:int = 100

var rng = RandomNumberGenerator.new()

var Rooms : Array[Room]
var CurrentHero : Hero
var player : Player

signal player_died()

func _ready():
	BossRoom.exit_reached.connect(take_damage)
	SafeRoom.exit_reached.connect(_on_room_exit_reached)
	player = $Player as Player
	player.player_death.connect(_handle_death)
	setup_room_managers()
	
func take_damage(room: Room):
	player.take_damage(CurrentHero.get_damage())
	handle_heroes_turn_complete()
	
func hero_died():
	player.add_money(CurrentHero.Money)
	handle_heroes_turn_complete()
	
func _on_button_pressed():
	setup_rooms()
	generate_heroes()
	pick_next_hero()
	%Play.visible = false

func _handle_death():
	player_died.emit()
	
func _on_room_exit_reached(room : Room):
	var next_room = room.get_next_room()
	
	# set the current hero to traverse the next room
	CurrentHero.set_room(next_room)
	
func _room_damage_dealt(damage : int):
	CurrentHero.take_damage(damage)
	
func handle_heroes_turn_complete():
	HeroParent.remove_child(CurrentHero)
	CurrentHero.queue_free()
	if not pick_next_hero():
		%Play.visible = true
		player.add_money(round_complete_prize * player.get_level())
	
func generate_heroes():
	var heroes_to_spawn = rng.randi_range(1, player.get_level() * 2)
	
	for i in heroes_to_spawn:
		var rand = rng.randi_range(0, PotentialHeros.size() - 1)
		var hero = PotentialHeros[rand].instantiate() as Hero
		hero.position.x = position.x + lerp(-50, 50, randf())
		hero.position.y = position.y + lerp(-50, 50, randf())
		HeroParent.add_child(hero)
	
		
func pick_next_hero() -> bool:
	var children = HeroParent.get_children()
	
	if children.size() == 0:
		player.level_complete()
		return false
		
	# pick the next hero to enter the dungeon
	var rand = rng.randi_range(0, children.size() - 1)
	
	CurrentHero = children[rand] as Hero
	CurrentHero.set_active(player.get_level())
	CurrentHero.set_initial_room(SafeRoom)
	CurrentHero.hero_death.connect(hero_died)
	return true
	
func setup_rooms():
	Rooms.clear()
	
	# loop through the children
	for node in RoomParent.get_children():
		var manager = node as RoomManager
		if not manager:
			continue
		
		var new_room = manager.get_room()
		if not new_room:
			continue
			
		Rooms.append(new_room)
			
	# if no rooms are present then just jump straight to the boss room	
	if Rooms.size() == 0:
		SafeRoom.set_next_room(BossRoom)
		return
		
	var last_room = SafeRoom
	for room in Rooms:
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
	player.add_money(-new_room.cost)
	manager.room_bought.disconnect(_buy_room)
	manager.room_upgraded.connect(_upgrade_room)
	
func _upgrade_room(cost:int):
	player.add_money(-cost)
	
func setup_room_managers():
	# loop through the children
	for node in RoomParent.get_children():
		var manager = node as RoomManager
		if not manager:
			print("is not manager")
			continue
			
		manager.set_can_buy(false)
		manager.room_bought.connect(_buy_room)
		
func _process(delta):
	for node in RoomParent.get_children():
		var manager = node as RoomManager
		if not manager:
			continue
		
		var cost = manager.get_cost()
		var player_money = player.get_money()
		
		if player_money >= cost:
			manager.set_can_buy(true)
		else:
			manager.set_can_buy(false)
			
		

