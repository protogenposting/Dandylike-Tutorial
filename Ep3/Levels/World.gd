extends Node3D
class_name Main

@export var levelNode : Node3D

@export var elevator : Elevator

@export_file_path() var floors : Array[String]

var currentFloor : Floor

var floorIsLoaded : bool = false

var tasksLeft : int = 0

var tasksTotal : int = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if tasksLeft <= 0:
		floorIsLoaded = false
	
	if elevator.playersInElevator > 0 && !floorIsLoaded:
		_load_floor()

func _load_floor():
	var newFloor : String = floors.pick_random()
	
	var newFloorScene : PackedScene = load(newFloor)
	
	tasksLeft = 4
	
	tasksTotal = 4
	
	currentFloor = newFloorScene.instantiate()
	
	for node in levelNode.get_children():
		node.queue_free()
	
	levelNode.add_child(currentFloor)
	
	floorIsLoaded = true
	
	currentFloor.global_position = elevator.global_position - currentFloor.elevatorPos.global_position
