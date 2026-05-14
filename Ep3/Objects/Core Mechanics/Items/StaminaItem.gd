extends Item

func _use(player : Player) -> bool:
	player.stamina += 50
	
	queue_free()
	
	return true
