extends Node3D

@export var levelNode : Node3D

@export var elevator : Elevator

@export_file_path() var floors : Array[String]

var currentFloor : Floor

var floorIsLoaded : bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if elevator.playersInElevator > 0 && !floorIsLoaded:
		_load_floor()

func _load_floor():
	var newFloor : String = floors.pick_random()
	
	var newFloorScene : PackedScene = load(newFloor)
	
	currentFloor = newFloorScene.instantiate()
	
	for node in levelNode.get_children():
		node.queue_free()
	
	levelNode.add_child(currentFloor)
	
	floorIsLoaded = true
	
	currentFloor.global_position = elevator.global_position - currentFloor.elevatorPos.global_position
