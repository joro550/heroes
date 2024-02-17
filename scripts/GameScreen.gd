extends Node2D
@export var SafeRoom : Room
@export var BossRoom : Room
@export var RoomParent : Node2D
@export var HeroParent : Node2D
@export var PotentialHeros : Array[PackedScene]

var rng = RandomNumberGenerator.new()

var Rooms : Array[Room]
var Heros : Array[Node]
var CurrentHero : Hero
var level : int = 1

func _ready():
	BossRoom._exit_reached.connect(take_damage)
	
func take_damage(room: Room):
	pick_next_hero()
	
func hero_died():
	CurrentHero.queue_free()
	pick_next_hero()
	
func _on_button_pressed():
	setup_rooms()
	generate_heroes()
	pick_next_hero()
	
func _on_room_exit_reached(room : Room):
	var next_room = room.get_next_room()
	
	# set the current hero to traverse the next room
	CurrentHero.set_room(next_room)
	room._exit_reached.disconnect(_on_room_exit_reached)
	
func generate_heroes():
	var rand = rng.rand_range(0, PotentialHeros.size())
	
	for i in range(0, rng.rand_range(level * 2, PotentialHeros.size())):
		var thing = PotentialHeros[rand].instance()
		thing.position.x = position.x + lerp(-50, 50, randf())
		thing.position.y = position.y + lerp(-50, 50, randf())
		HeroParent.add_child(thing as Hero)
	
func pick_next_hero():
	var children = HeroParent.get_children()
	if children.size() == 0:
		print("no more heroes")
		pass
	
	var rand = rng.randf_range(0, children.size())
	
	CurrentHero = children[rand] as Hero
	CurrentHero.set_active(true)
	CurrentHero.set_initial_room(SafeRoom)
	CurrentHero.hero_death.connect(hero_died)
	
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
		SafeRoom._exit_reached.connect(_on_room_exit_reached)
		return
		
	SafeRoom._exit_reached.connect(_on_room_exit_reached)
	
	var last_room = SafeRoom
	
	for room in Rooms:
		last_room.set_next_room(room)
		room._exit_reached.connect(_on_room_exit_reached)
		last_room = room
		
	last_room.set_next_room(BossRoom)

