extends Area3D
class_name Item

@export var itemName : String
@export_multiline() var itemDescription : String
@export var itemTexture : Texture2D

var isPickedUp : bool = false

func _process(delta: float) -> void:
	visible = !isPickedUp

func _use(player : Player) -> bool:
	player.stamina += 50
	
	queue_free()
	
	return true
