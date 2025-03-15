extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -400.0
const CLIMB_SPEED = 150

@onready var sprite = $sprite

var on_ladder = false

#urcare verticala scara
func _on_ladder_body_entered(body: Node2D) -> void:
	
	on_ladder = true

func _on_ladder_body_exited(body: Node2D) -> void:
	on_ladder = false
		
func _physics_process(delta: float) -> void:
	# Add the gravity.
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	# Cățărare pe scară
	if on_ladder:
		velocity.y = 0
		if Input.is_action_pressed("ui_up"):
			velocity.y = -CLIMB_SPEED
		if Input.is_action_pressed("ui_down"):
			velocity.y = CLIMB_SPEED
			
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	
	if direction :
		
		velocity.x = direction * SPEED
		
		if direction > 0:  # >0 adica se misca pozitiv pe x, animatie normala de walk
			sprite.play("walk")
		else:
			sprite.play("backwards")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		sprite.play("idle")	
		
	move_and_slide()
	
