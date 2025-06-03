# Layer 6, Mask 1
extends CharacterBody2D

@export var move_speed: float = 40.0
@export var gravity: float = 400.0
@export var follow_distance: float = 80.0
@export var teleport_distance: float = 300.0
@onready var raycast_left = $FloorCheckerLeft  
@onready var raycast_right = $FloorCheckerRight

var is_tamed := false
var is_player_nearby := false
var player: CharacterBody2D = null
const jump_velocity = -200.0
var is_at_platform_edge := false

var direction := 1
var random_move_timer := 0.0

func _ready() -> void:
	randomize()
	$ProximityArea.body_entered.connect(_on_proximity_area_body_entered)
	$ProximityArea.body_exited.connect(_on_proximity_area_body_exited)

func _process(delta: float) -> void:
	if not is_tamed and is_player_nearby and player:
		if Input.is_action_just_pressed("tame"):
			tame()

func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	
	if is_on_floor():
		check_for_platform_edge()
	
	if is_tamed and player:
		follow_player(delta)
		handle_jump(delta)
	else:
		handle_wild_behavior(delta)

	update_animation()

	move_and_slide()

func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0.0

func handle_wild_behavior(delta: float) -> void:
	if is_on_floor():
		check_for_platform_edge()
		check_wall_and_turn()
		random_move_timer -= delta
		if random_move_timer <= 0:
			direction = randi() % 3 - 1  # 1, 0 or -1
			random_move_timer = randf_range(1.0, 3.0)
	velocity.x = direction * move_speed
	
func check_wall_and_turn() -> void:
	if is_on_wall():
		direction *= -1

func update_animation() -> void:
	if not is_on_floor():
		$AnimatedSprite2D.play("jump")
	elif velocity.x != 0:
		$AnimatedSprite2D.play("walk")
	else:
		$AnimatedSprite2D.play("idle")
	$AnimatedSprite2D.flip_h = velocity.x < 0

func handle_jump(delta: float) -> void:
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = jump_velocity
		print("Animal is jumping! velocity.y = ", velocity.y)  # Debugging the jump

func follow_player(delta: float) -> void:
	# Teleport the animal if it is too far
	var distance = position.distance_to(player.position)
	if distance > teleport_distance and player.is_on_floor():
		position = player.position + Vector2(-16, 0)
		velocity = Vector2.ZERO
		return
		
	if is_at_platform_edge: # If the animal is at the platform edge and it is tamed, make it stop
		velocity.x = 0.0  
		update_animation()
	
	if not is_at_platform_edge: # If the animal is not at the platform edge it should follow the tamer
		if distance > follow_distance:
			direction = sign(player.position.x - position.x)
			velocity.x = direction * move_speed
			update_animation()  
		else:
			velocity.x = 0.0
			update_animation()

func tame() -> void:
	if player.tamed_animal:
		print("Player already has a tamed animal.")
		return
	
	is_tamed = true
	player.tamed_animal = self
	$AnimatedSprite2D.play("idle")
	$RedPandaSound.play()
	print("The animal was tamed successfully")

func _on_proximity_area_body_entered(body: Node) -> void:
	if body.name == "player":
		is_player_nearby = true
		player = body as CharacterBody2D

func _on_proximity_area_body_exited(body: Node) -> void:
	if body.name == "player":
		is_player_nearby = false

#Function to prevent the animal from falling off platforms
func check_for_platform_edge() -> void:  
	var left_colliding = raycast_left.is_colliding()
	var right_colliding = raycast_right.is_colliding()
	is_at_platform_edge = false
	
	if is_tamed == true:
		if not left_colliding or not right_colliding:
			is_at_platform_edge = true
			velocity.x = 0.0
			$AnimatedSprite2D.play("idle")
			return
	else:
		if direction < 0 and not left_colliding:
			direction = 1
			print("Detected platform edge on left")
		elif direction > 0 and not right_colliding:
			direction = -1
			print("Detected platform edge on right")
