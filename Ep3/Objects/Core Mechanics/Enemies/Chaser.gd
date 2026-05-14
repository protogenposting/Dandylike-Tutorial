extends CharacterBody3D
class_name Enemy

@export var agent : NavigationAgent3D

@export var lineOfSight : ShapeCast3D

@export var wallcast : RayCast3D

@export var hitbox : ShapeCast3D

var target : Player

var accel = 50

var runSpeed = 7

var attention : float = 0

var floor : Floor

var pauseTime : float = 0

func _ready() -> void:
	floor = get_tree().get_first_node_in_group("Floor")

func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity += get_gravity() * delta
	
	pauseTime -= delta
	
	if target && pauseTime <= 0:
		agent.target_position = target.global_position
		
		_rotate_towards(target.global_position)
		
		wallcast.target_position = to_local(target.global_position)
		
		if !_can_see_point(target.global_position):
			attention -= delta
			
			if attention <= 0:
				target = null
		else:
			attention += delta
			
			attention = clamp(attention, 0, 3)
		
		for result in hitbox.collision_result:
			if result.collider is Player:
				_hurt(result.collider)
	elif pauseTime <= 0:
		_rotate_towards(agent.get_next_path_position())
		
		if agent.is_navigation_finished():
			agent.target_position = floor._get_random_poi()
			
			pauseTime = 1
	else:
		velocity = velocity.move_toward(Vector3.ZERO, accel * delta)
	
	if pauseTime <= 0:
		if lineOfSight.is_colliding():
			for result in lineOfSight.collision_result:
				if result.collider is Player && _can_see_point(result.collider.global_position):
					target = result.collider
					
					attention = 3
		
		var pos : Vector3 = agent.get_next_path_position()
		
		var dir : Vector3 = Vector3(pos.x - global_position.x, 0, pos.z - global_position.z).normalized()
		
		var oldY = velocity.y
		
		velocity.y = 0
		
		velocity = velocity.move_toward(dir * runSpeed, accel * delta)
		
		velocity.y = oldY
	
	move_and_slide()

func _can_see_point(point : Vector3) -> bool:
	wallcast.target_position = to_local(point)
	
	wallcast.force_raycast_update()
	
	return !wallcast.is_colliding()

func _rotate_towards(pos):
	var angle = Vector2(global_position.x, global_position.z).angle_to_point(Vector2(pos.x, pos.z))
	
	angle = -(angle - deg_to_rad(90))
	
	rotation.y = angle

func _hurt(player : Player):
	player.health -= 1
	
	pauseTime = 3
	
	target = null
	
	print(player)
