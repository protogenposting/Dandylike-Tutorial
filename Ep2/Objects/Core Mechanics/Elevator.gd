extends Node3D
class_name Elevator

@export var area : Area3D
@export var playerCountArea : Area3D
@export var animationPlayer : AnimationPlayer

var playersInElevator : int

func _process(delta: float) -> void:
	var playerIsTouching : bool = false
	
	playersInElevator = 0
	
	for node in area.get_overlapping_bodies():
		if node.is_in_group("Player"):
			playerIsTouching = true
	
	for node in playerCountArea.get_overlapping_bodies():
		if node.is_in_group("Player"):
			playersInElevator += 1
	
	if playerIsTouching:
		animationPlayer.play("Open")
	else:
		animationPlayer.play("Closed")
