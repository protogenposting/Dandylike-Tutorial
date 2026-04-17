extends CharacterBody3D


var currentSpeed : float = 5
var sensitivity : float = 0.1

@export var cameraPivot : Node3D

@export var speedScaling : Curve

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	_load_character(
		load("res://BaseCharacter.tscn")
	)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		cameraPivot.rotate_x(deg_to_rad(-event.relative.y * sensitivity))
		rotate_y(deg_to_rad(-event.relative.x * sensitivity))
		
		cameraPivot.rotation.x = clamp(cameraPivot.rotation.x, deg_to_rad(-80), deg_to_rad(80))

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("Left", "Right", "Forward", "Backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * currentSpeed
		velocity.z = direction.z * currentSpeed
	else:
		velocity.x = move_toward(velocity.x, 0, currentSpeed)
		velocity.z = move_toward(velocity.z, 0, currentSpeed)
	
	move_and_slide()

func _load_character(character : PackedScene):
	var newCharacter : Character = character.instantiate()
	
	$Character.add_child(newCharacter)
	
	currentSpeed = speedScaling.sample(newCharacter.speed)
