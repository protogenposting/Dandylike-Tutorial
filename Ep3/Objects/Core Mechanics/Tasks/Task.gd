extends Node3D
class_name Task

@export var locksPlayer : bool

@export var playerPos : Node3D

var main : Main

var playerDoing : Player

var progress : float = 0

var completed : bool

func _ready() -> void:
	main = get_tree().get_first_node_in_group("Main")

func _physics_process(delta: float) -> void:
	if playerDoing && locksPlayer:
		playerDoing.global_position = playerPos.global_position
		
		playerDoing.velocity = Vector3.ZERO

func _completed():
	completed = true
	
	playerDoing = null
	
	main.tasksLeft -= 1

func _start(player : Player):
	playerDoing = player

func _leave():
	playerDoing = null
