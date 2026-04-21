extends Node3D
class_name Floor

@export var elevatorPos : Node3D

@export var itemSpawnPositions : Node3D

var item : PackedScene = load("res://Objects/Core Mechanics/Items/Item.tscn")

func _ready() -> void:
	var spawnPositions : Array = itemSpawnPositions.get_children()
	
	for i in 5:
		var child : Node3D = spawnPositions.pick_random()
		
		var newItem : Item = item.instantiate()
		
		add_child(newItem)
		
		newItem.position = child.position
		
		spawnPositions.erase(child)
		
		child.queue_free()
