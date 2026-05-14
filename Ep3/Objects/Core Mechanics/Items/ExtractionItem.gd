extends Item

func _use(player : Player) -> bool:
	queue_free()
	return true
