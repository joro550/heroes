extends Node2D
@export var SafeRoom: Room
@export var BossRoom: Room
@export var Rooms :Array[Room]
@export var CurrentHero: Hero

@export var Heros : Array[Node]

var rng = RandomNumberGenerator.new()

func _ready():
	BossRoom._exit_reached.connect(take_damage)
	
func take_damage(room: Room):
	print("taking damage")
	
func _on_button_pressed():
	setup_rooms()
	
	var my_random_number = rng.randf_range(0, Heros.size())
	Heros[my_random_number].set_active(true)
	
	
func _on_room_exit_reached(room : Room):
	var next_room = room.get_next_room()
	var next_entrance = next_room.get_entrance().global_position
	CurrentHero.move_to_position(next_entrance)
	
	room._exit_reached.disconnect(_on_room_exit_reached)
	
func setup_rooms():
	# if no rooms are present then just jump straight to the boss room	
	if Rooms.size() == 0:
		SafeRoom._exit_reached.connect(_on_room_exit_reached)
		SafeRoom.set_next_room(BossRoom)
		print("setting next room to boss room")
		return 
		
	SafeRoom.set_next_room(Rooms[0])
	SafeRoom._exit_reached.connect(_on_room_exit_reached)
	
	for i in range(1, Rooms.size()):
		if i != Rooms.size() - 1:
			Rooms[i]._exit_reached.connect(_on_room_exit_reached)
			Rooms[i].set_next_room(Rooms[i+1])
	
	var lastRoom = Rooms.size() - 1
	Rooms[lastRoom].set_next_room(BossRoom)
