extends Task

func _physics_process(delta: float) -> void:
	super(delta)
	
	$Button.visible = playerDoing != null
	
	if playerDoing != null:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_button_pressed() -> void:
	if playerDoing:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		
		_completed()
		
		print("COMLETE")
