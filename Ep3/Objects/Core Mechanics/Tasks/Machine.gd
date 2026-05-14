extends Task

var time : float = 5

func _physics_process(delta: float) -> void:
	super(delta)
	
	$Sprite3D/SubViewport/ProgressBar.value = progress
	
	$Sprite3D/SubViewport/ProgressBar.max_value = time
	
	if playerDoing:
		progress += delta
		
		if progress >= time:
			_completed()
