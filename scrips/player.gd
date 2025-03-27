#cd onedrive\documente\pirate-game
#git add .
#git commit -m "Commit #10 : Fixed animations, Movement "
#git push origin main

# contrls 
#-> movement : arrows
#-> attack 1,2,3 : F,G,H
#-> sw_throw : E , pickup : 
#-> air_attack 1,2: 1,2   

extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -400.0
const CLIMB_SPEED = 150

@onready var Attack_Hitbox = $Attack_Hitbox
@onready var Attack_Cooldown = $Attack_Cooldown
@onready var sprite = $sprite
@onready var attacking = $Attack_Animation
@export var sword_scene = preload("res://scenes/sword.tscn")  # Scena sabiei fizice

var on_ladder = false

var max_health = 100
var health = max_health
var damage = 20  # Cât damage dă jucătorul
var y = 0;
var can_attack = true
var animation_flag = false # flag pentru a nu se intrerupe animatiile
var has_sword = true
var can_pickup_sword = false

# functii pentru health/ take damage
func _ready():
	$HealthBar.value = health

func take_damage(amount):
	health -= amount
	$HealthBar.value = health
	$HealthBar/TextureProgressBar.update(health, max_health)
	animation_flag = true
	
	if has_sword :
		sprite.play("attacked")
	else:
		sprite.play("attacked_ns")
		
	attacking.start()
	
	if health <= 0:
		die()


func die():
	print("Ai murit!")
	get_tree().reload_current_scene()

func attack_enemy(enemy):
	if enemy.has_method("take_damage"):
		enemy.take_damage(damage)

#urcare verticala scara
func _on_ladder_body_entered(body: Node2D) -> void:
	on_ladder = true

func _on_ladder_body_exited(body: Node2D) -> void:
	on_ladder = false
		
func _physics_process(delta: float) -> void:
		
	if not is_on_floor():
		# facem inca un collision shape care detecteaza cand o sa fie pe sol
		# si opreste animatia
		#print(global_position.y, y)
		
		velocity += get_gravity() * delta
		if(velocity[1] > 0 ): # doar la cadere
			sprite.play("fall")

	#else:
		#animation_flag = false

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() :
		sprite.play("jump")
		animation_flag = true
		#y = global_position.y
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
	
	# am pus 2 if-uri pentru a nu bloca miscarea jucatorului in timpul atacului, doar animatia
	if abs(direction) > 0 :
		velocity.x = direction * SPEED 
		if not animation_flag :
			# animatii
			if direction > 0 :  # >0 adica se misca pozitiv pe x, animatie normala de walk
				if has_sword :
					sprite.flip_h = false; # flip imagine horizontal
					sprite.play("walk")
				else: 
					sprite.flip_h = false; # flip imagine horizontal
					sprite.play("walk_ns")	
			else:
				if has_sword :
					sprite.flip_h = true;
					sprite.play("walk")
				else: 
					sprite.flip_h = true; # flip imagine horizontal
					sprite.play("walk_ns")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED) # oprim caracterul
		if not animation_flag:
			print("idle")
			if has_sword:
				sprite.play("idle")
					
			else: 
				sprite.play("idle_hs")	
				#print("idle_hs")
	
	if Input.is_action_just_pressed("ui_attack1") and can_attack and has_sword:
		attack("attack_1")
	if Input.is_action_just_pressed("ui_attack2") and can_attack and has_sword:
		attack("attack_2")
	if Input.is_action_just_pressed("ui_attack3") and can_attack and has_sword:
		attack("attack_3")
	if Input.is_action_just_pressed("air_attack1") and can_attack and not is_on_floor() and has_sword:
		attack("air_attack_1")
	if Input.is_action_just_pressed("air_attack2") and can_attack and not is_on_floor() and has_sword:
		attack("air_attack_2")

		# Aruncă sabia
	if has_sword and Input.is_action_just_pressed("throw_sword"):
		throw_sword()

	# Ridică sabia , este apelata din sword
	
	#if can_pickup_sword and Input.is_action_just_pressed("pickup"):
		#pickup_sword()
		#print("picked up")
		
	if Input.is_action_just_pressed("Restart"):
		get_tree().reload_current_scene();


	move_and_slide()

# pentru a pune un cooldown pe attack
func _on_cooldown_timeout() -> void:
	can_attack = true
	

func _on_attack_animation_timeout() -> void:
	animation_flag = false

	
# sword mechanics
func throw_sword():
	
	animation_flag = true
	sprite.play("sword_throw")
	attacking.start(0.2) # pentru afisare animatie 
	has_sword = false

	var sword = sword_scene.instantiate()
	sword.global_position = global_position
	get_parent().add_child(sword)
	
	
	# Setează direcția aruncării
	var throw_direction = Vector2( 1 if not sprite.flip_h else -1 ,  0)
	# maybe better ??
	sword.throw_sword((throw_direction) + velocity * 0.5)
	print(throw_direction)  
	#sword.throw_sword(throw_direction * 200)
	#sword.throw_sword(throw_direction.normalized() * 600)  # Adjust 600 to desired speed
	
func pickup_sword():
	has_sword = true
	can_pickup_sword = false
	
func attack(attack_animation):
	can_attack = false # pentru a nu se face spam de attack
	animation_flag = true # pentru a nu interveni alte animatii
	attacking.start()
	sprite.play(attack_animation)
	Attack_Cooldown.start()
	
	# verificam in ce directie se uita playerul pentru a lua hitboxul de acolo
	var facing = 1 ; # 1 in fata , -1 in spate 
	if sprite.flip_h == true :
		facing = -1;
	
	#aici se poate implementa o functie, pt ca este redundanta scrierea
	if facing  == 1: 
		if Attack_Hitbox.is_colliding():
			print("colliding")
			var enemy = Attack_Hitbox.get_collider()
			print(enemy.name)

			#for i in Attack_Hitbox.get_collider(): # pentru un attack de tip multiple
			if enemy and ( enemy.name == "Enemy"):
				print("Atac")
				if has_sword:
					enemy.take_damage(damage)
				else:
					print(" You have no weapon !!! ")
	else: # se uita in spate damage in spate
		print("behind")
		if $Attack_Hitbox_behind.is_colliding():
			print("colliding")
			var enemy = $Attack_Hitbox_behind.get_collider()
			print(enemy.name)

			#for i in Attack_Hitbox.get_collider(): # pentru un attack de tip multiple
			if enemy and ( enemy.name == "Enemy"):
				print("Atac")
				if has_sword:
					enemy.take_damage(damage)
				else:
					print(" You have no weapon !!! ")

	

var exited = false;
func _on_ground_detect_body_entered(body: Node2D) -> void:
	# pentru a gestiona animatia de fall si jump
	# este necesar sa se faca de un collision shape pentru a detecta ground
	# mecanica se bazeaza pe pricipiul :
	# player doar cand se stie ca a iesit din zona(adica ground) poate sa se activeze
	# pentru a nu se tine non stop animation-flag pornit 
	if exited:
		print("Touched ground")
		animation_flag = false # poate rula idle
		exited = false


func _on_ground_detect_body_exited(body: Node2D) -> void:
	print("Jumped")
	exited = true
