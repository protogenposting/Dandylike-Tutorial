extends Node3D
class_name Floor

@export var elevatorPos : Node3D

@export var itemSpawnPositions : Node3D

@export var enemyPOIPositions : Node3D

@export var taskSpawnPositions : Node3D

@export var wickedSpawnPositions : Node3D

var item : Array[PackedScene] = [
	load("res://Objects/Core Mechanics/Items/StaminaItem.tscn"),
	load("res://Objects/Core Mechanics/Items/ExtractionItem.tscn")
]

var taskTypes : Array[PackedScene] = [
	load("res://Objects/Core Mechanics/Tasks/Button.tscn"),
	load("res://Objects/Core Mechanics/Tasks/Machine.tscn"),
	load("res://Objects/Core Mechanics/Tasks/Puzzle.tscn")
]

var enemy : PackedScene = load("res://Objects/Core Mechanics/Enemies/Chaser.tscn")

var main : Main

func _ready() -> void:
	main = get_tree().get_first_node_in_group("Main")
	
	var spawnPositions : Array = itemSpawnPositions.get_children()
	
	for i in 5:
		var child : Node3D = spawnPositions.pick_random()
		
		var newItem : Item = item.pick_random().instantiate()
		
		add_child(newItem)
		
		newItem.position = child.position
		
		spawnPositions.erase(child)
		
		child.queue_free()
	
	var taskPositions = taskSpawnPositions.get_children()
	
	for i in main.tasksTotal + 2:
		var newPos : Node3D = taskPositions.pick_random()
		
		var newTask : Task = taskTypes.pick_random().instantiate()
		
		add_child(newTask)
		
		newTask.global_position = newPos.global_position
		
		newPos.queue_free()
		
		taskPositions.erase(newPos)
	
	var newEnemy : Enemy = enemy.instantiate()
	
	add_child(newEnemy)
	
	newEnemy.global_position = wickedSpawnPositions.get_children().pick_random().global_position

func _get_random_poi() -> Vector3:
	return enemyPOIPositions.get_children().pick_random().global_position
