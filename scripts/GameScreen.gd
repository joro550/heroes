extends Node2D
@export var SafeRoom : Room
@export var BossRoom : Room
@export var RoomParent : Node2D
@export var HeroParent : Node2D
@export var PotentialHeros : Array[PackedScene]

var rng = RandomNumberGenerator.new()

var Rooms : Array[Room]
var CurrentHero : Hero
var level : int = 1

func _ready():
	BossRoom.exit_reached.connect(take_damage)
	SafeRoom.exit_reached.connect(_on_room_exit_reached)
	
func take_damage(room: Room):
	handle_heroes_turn_complete()
	
func hero_died():
	handle_heroes_turn_complete()
	
func _on_button_pressed():
	setup_rooms()
	generate_heroes()
	pick_next_hero()
	%Play.visible = false
	
func _on_room_exit_reached(room : Room):
	var next_room = room.get_next_room()
	
	# set the current hero to traverse the next room
	CurrentHero.set_room(next_room)
	
func handle_heroes_turn_complete():
	HeroParent.remove_child(CurrentHero)
	CurrentHero.queue_free()
	if not pick_next_hero():
		%Play.visible = true
	
func generate_heroes():
	var heroes_to_spawn = rng.randi_range(1, level * 2)
	
	for i in heroes_to_spawn:
		var rand = rng.randi_range(0, PotentialHeros.size() - 1)
		var hero = PotentialHeros[rand].instantiate() as Hero
		hero.position.x = position.x + lerp(-50, 50, randf())
		hero.position.y = position.y + lerp(-50, 50, randf())
		HeroParent.add_child(hero)
	
		
func pick_next_hero() -> bool:
	var children = HeroParent.get_children()
	
	if children.size() == 0:
		level += 1
		return false
		
	# pick the next hero to enter the dungeon
	var rand = rng.randi_range(0, children.size() - 1)
	
	CurrentHero = children[rand] as Hero
	CurrentHero.set_active(true)
	CurrentHero.set_initial_room(SafeRoom)
	CurrentHero.hero_death.connect(hero_died)
	return true
	
func setup_rooms():
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
		room.exit_reached.disconnect(_on_room_exit_reached)
		room.exit_reached.connect(_on_room_exit_reached)
		last_room = room
		
	last_room.set_next_room(BossRoom)

