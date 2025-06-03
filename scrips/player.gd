#
#cd onedrive\documente\pirate-game
#git add .
#git commit -m "Bug fixing"
#git push -u origin main

# contrls 
#-> movement : arrows
#-> attack 1,2,3 : F,G,H
#-> sw_throw : E , pickup : 
#-> air_attack 1,2: 1,2   

extends CharacterBody2D

#const SPEED = 150.0
var speed = 150.0
const JUMP_VELOCITY = -400.0
const CLIMB_SPEED = 150

@onready var Attack_Hitbox = $Attack_Hitbox
@onready var Attack_Cooldown = $Attack_Cooldown
@onready var sprite = $sprite
@onready var dust_particles = $DustParticles
@onready var dust_particles_flipped = $DustParticles_flipped
@onready var jump_particles = $JumpParticles
@export var inv: Inv

@onready var speed_timer: Timer = $SpeedTimer
@onready var damage_timer: Timer = $DamageTimer
var bonus_speed := 100
var bonus_dmg := 10

const base_speed = 150.0
const base_dmg = 20

var speed_boost_active := false
var damage_boost_active := false


@onready var attacking = $Attack_Animation
@export var sword_scene = preload("res://scenes/sword.tscn")  # Scena sabiei fizice
#@export var prtcls = preload("res://scenes/particles.tscn")
#var particles = prtcls.instantiate()

var has_key = false

var on_ladder = false

var max_health = 100
var health = max_health
var damage = 20  # Cât damage dă jucătorul
var y = 0;
var can_attack = true
var animation_flag = false # flag pentru a nu se intrerupe animatiile
var has_sword = true
var can_pickup_sword = false
var tamed_animal: CharacterBody2D = null

var blue_potions = 0
var red_potions = 0
var score = 0

func collect_key():
	has_key = true
	print(has_key)

# functii pentru health/ take damage
func _ready():
	$HealthBar.value = health
	#get_parent().add_child(particles)

func is_dead():
	return health <= 0
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
			if has_sword:
				sprite.play("fall")
			else:
				sprite.play("fall_ns")

	#else:
		#animation_flag = false

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() :
		if has_sword:
			dust_particles_flipped.visible = false
			dust_particles.visible = false
			sprite.play("jump")
			animation_flag = true
			#y = global_position.y
			velocity.y = JUMP_VELOCITY
			
			#particles.global_position = Vector2(600, -1500)
			#particles.jump(Vector2(600, -1500))
			#jump_particles.global_position = global_position
			#await get_tree().create_timer(0.5).timeout
			#jump_particles.visible = false

		else:
			dust_particles.visible = false
			dust_particles_flipped.visible = false
			
			sprite.play("jump_ns")
			animation_flag = true
			#y = global_position.y
			velocity.y = JUMP_VELOCITY
		
		
	# Cățărare pe scară
	if on_ladder:
		velocity.y = CLIMB_SPEED * 0.4
		if Input.is_action_pressed("ui_up"):
			velocity.y = -CLIMB_SPEED
		if Input.is_action_pressed("ui_down"):
			velocity.y = CLIMB_SPEED
			
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	
	# am pus 2 if-uri pentru a nu bloca miscarea jucatorului in timpul atacului, doar animatia
	if abs(direction) > 0 :
		velocity.x = direction * speed#SPEED 
		if not animation_flag :
			# animatii
			if direction > 0 :  # >0 adica se misca pozitiv pe x, animatie normala de walk
				if has_sword :
					sprite.flip_h = false; # flip imagine horizontal
					sprite.play("walk")
					
					dust_particles.visible = true
					dust_particles.play("walk")

				else: 
					sprite.flip_h = false; # flip imagine horizontal
					sprite.play("walk_ns")	
					
					dust_particles.visible = true
					dust_particles.play("walk")
			else:
				dust_particles.visible = false
				if has_sword :
					sprite.flip_h = true;
					sprite.play("walk")
					
					dust_particles_flipped.visible = true
					dust_particles_flipped.play("walk")
				else: 
					dust_particles_flipped.visible = true
					dust_particles_flipped.play("walk")
					
					sprite.flip_h = true; # flip imagine horizontal
					sprite.play("walk_ns")
	else:
		velocity.x = move_toward(velocity.x, 0, speed)#SPEED) # oprim caracterul
		if not animation_flag:
			if has_sword:
				sprite.play("idle")
				dust_particles.visible = false
				dust_particles_flipped.visible = false
			else: 
				sprite.play("idle_hs")	
				dust_particles.visible = false
				dust_particles_flipped.visible = false


	
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
	
	# daca are potiuni in inventar poate apasa Z, respectiv X pentru a folosi potiunile Blue/Red
	if Input.is_action_just_pressed("use_red_pot"):
		use_item("red_potion")
	if Input.is_action_just_pressed("use_blue_pot"):
		use_item("blue_potion")


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
	#print(throw_direction)  
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
			if enemy and ( enemy.is_in_group("Enemies")):
				print("Atac")
				if has_sword:
					enemy.take_damage(damage, facing)
				else:
					print(" You have no weapon !!! ")
	else: # se uita in spate damage in spate
		print("behind")
		if $Attack_Hitbox_behind.is_colliding():
			print("colliding")
			var enemy = $Attack_Hitbox_behind.get_collider()
			print(enemy.name)

			#for i in Attack_Hitbox.get_collider(): # pentru un attack de tip multiple
			if enemy and ( enemy.is_in_group("Enemies")):
				print("Atac")
				if has_sword:
					enemy.take_damage(damage, facing)
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
		animation_flag = false # poate rula idle
		exited = false


func _on_ground_detect_body_exited(body: Node2D) -> void:

	exited = true

func pick_up_potion(type):
	if type == "Blue Potion":
		blue_potions += 1
	
	if type == "Red Potion":
		red_potions += 1
	
func tresure_pick_up(type):
	if type == "Red Diamond":
		score += 1000

func use_item(item_name: String):
	if inv.has_item(item_name):
		match item_name:
			"red_potion":
				apply_damage_boost()
			"blue_potion":
				apply_speed_boost()
		inv.remove_item(item_name, 1)
	else:
		print("No potions available", item_name)

func apply_speed_boost():
	if speed_boost_active:
		return
	speed = base_speed + bonus_speed
	speed_timer.start(5)
	speed_boost_active = true
	#potion_sound.play()
	print("Speed boost activ!")

func apply_damage_boost():
	if damage_boost_active:
		return
	damage = base_dmg + bonus_dmg
	damage_timer.start(5)
	damage_boost_active = true
	#potion_sound.play()
	print("Damage boost activ!")
	
func _on_speed_timer_timeout():
	speed = base_speed
	speed_boost_active = false
	print("Speed boost terminat.")

func _on_damage_timer_timeout() -> void:
	damage = base_dmg
	damage_boost_active = false
	print("Damage boost terminat.")

func red_potion():
	red_potions -= 1
	health += 20 
	
func blue_potion():
	blue_potions -= 1
	# buff

func collect(item: InvItem):
	print("Collecting item:", item.name)
	inv.insert(item)

func on_dust_particles_finished():
	print("stopped")
	dust_particles.visible = false
