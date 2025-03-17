extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -400.0
const CLIMB_SPEED = 150

@onready var Attack_Hitbox = $Attack_Hitbox
@onready var Attack_Cooldown = $Attack_Cooldown
@onready var sprite = $sprite
@onready var attacking = $Attack_Animation

var on_ladder = false

var max_health = 100
var health = max_health
var damage = 20  # Cât damage dă jucătorul
var can_attack = true
var is_attacking = false # flag pentru a nu se intrerupe animatiile

# functii pentru health/ take damage
func _on_ready() -> void: # incepe cu maxim health
	$HealthBar.value = health

func take_damage(amount):
	health -= amount
	$HealthBar.value = health
	if health <= 0:
		die()

func die():
	print("Ai murit!")
	get_tree().reload_current_scene()


func attack_enemy(enemy):
	if enemy.has_method("take_damage"):
		enemy.take_damage(damage)

#


#urcare verticala scara
func _on_ladder_body_entered(body: Node2D) -> void:
	
	on_ladder = true

func _on_ladder_body_exited(body: Node2D) -> void:
	on_ladder = false
		
func _physics_process(delta: float) -> void:
		
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
	
	if direction and not is_attacking :
		
		velocity.x = direction * SPEED
		
		if direction > 0 :  # >0 adica se misca pozitiv pe x, animatie normala de walk
			sprite.flip_h = false; # flip imagine horizontal
			sprite.play("walk")
		else:
			sprite.flip_h = true;
			sprite.play("walk")
	elif not is_attacking:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		sprite.play("idle")	
	
	
	if Input.is_action_pressed("ui_attack") and can_attack:
		#play here animation
		can_attack = false # pentru a nu se face spam de attack
		is_attacking = true # pentru a nu interveni alte animatii
		attacking.start()
		sprite.play("attack")
		Attack_Cooldown.start()
		
		if Attack_Hitbox.is_colliding():
			print("colliding")
			var enemy = Attack_Hitbox.get_collider()
			print(enemy)
			#for i in Attack_Hitbox.get_collider(): # pentru un attack de tip multiple
			if enemy and ( enemy.is_in_group("Enemies") or enemy.is_in_group("Enemy") ):
				print("Atac")
				enemy.take_damage(damage)


	move_and_slide()

# pentru a pune un cooldown pe attack
func _on_cooldown_timeout() -> void:
	can_attack = true
	

func _on_attack_animation_timeout() -> void:
	is_attacking = false # Replace with function body.
