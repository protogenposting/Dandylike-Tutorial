extends CharacterBody3D
class_name Player

var currentSpeed : float = 5
var runSpeed : float = 7
var walkSpeed : float = 5
var accel : float = 1
var sensitivity : float = 0.1

var stamina : float = 0
var maxStamina : float = 0
var staminaDrainRate : float = 0.3
var staminaRegenRate : float = 4
var staminaPauseTime : float = 0.5
var currentStaminaPauseTime : float
var isRunning : bool

# Item Variables
var inventory : Array[Item]
var inventorySlots : int = 3
@export var inventoryBox : HBoxContainer

@export var cameraPivot : Node3D
@export var staminaBar : ProgressBar

@export var walkSpeedScaling : Curve
@export var runSpeedScaling : Curve
@export var staminaScaling : Curve

@export var interactionShape : Area3D


func _ready() -> void:
	inventory.resize(inventorySlots)
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	_load_character(
		load("res://Objects/Core Mechanics/Characters/BaseCharacter.tscn")
	)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		cameraPivot.rotate_x(deg_to_rad(-event.relative.y * sensitivity))
		rotate_y(deg_to_rad(-event.relative.x * sensitivity))
		
		cameraPivot.rotation.x = clamp(cameraPivot.rotation.x, deg_to_rad(-60), deg_to_rad(60))

func _physics_process(delta: float) -> void:
	# Check For Interactables
	for area in interactionShape.get_overlapping_areas():
		if area is Item && Input.is_action_just_pressed("Interact"):
			var firstEmptySlot = inventory.find(null)
			
			if firstEmptySlot == -1:
				continue
			
			inventory[firstEmptySlot] = area
			
			area.reparent(self)
			
			area.isPickedUp = true
	
	# Inventory
	for i in inventoryBox.get_child_count():
		var child : TextureRect = inventoryBox.get_child(i)
		
		if inventory[i] != null:
			child.texture = inventory[i].itemTexture
		else:
			child.texture = null
		
		if Input.is_action_just_pressed("ItemSlot" + str(i + 1)):
			if inventory[i] != null:
				var result = inventory[i]._use(self)
				
				if result:
					inventory[i] = null
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	currentStaminaPauseTime -= delta
	
	# Stamina
	if stamina < maxStamina && currentStaminaPauseTime <= 0 && !isRunning:
		stamina += staminaRegenRate * delta
	
	if Input.is_action_just_pressed("Run") && stamina > 0:
		isRunning = true
	elif Input.is_action_just_released("Run"):
		isRunning = false
		
		currentStaminaPauseTime = staminaPauseTime
	
	if isRunning:
		stamina -= staminaDrainRate
		
		if stamina <= 0:
			isRunning = false
			
			currentStaminaPauseTime = staminaPauseTime
		
		currentSpeed = runSpeed
	else:
		currentSpeed = walkSpeed
	
	staminaBar.max_value = maxStamina
	
	staminaBar.value = stamina
	
	# Movement
	var input_dir := Input.get_vector("Left", "Right", "Forward", "Backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	var oldY = velocity.y
	
	velocity.y = 0
	
	if direction:
		velocity = velocity.move_toward(currentSpeed * direction, accel)
	else:
		velocity = velocity.move_toward(Vector3.ZERO, accel)
	
	velocity.y = oldY
	
	move_and_slide()

func _load_character(character : PackedScene):
	var newCharacter : Character = character.instantiate()
	
	$Character.add_child(newCharacter)
	
	walkSpeed = walkSpeedScaling.sample(newCharacter.speed)
	
	runSpeed = runSpeedScaling.sample(newCharacter.speed)
	
	maxStamina = staminaScaling.sample(newCharacter.stamina)
