extends CharacterBody2D

var SPEED = 20
const JUMP_VELOCITY = -400.0
const CLIMB_SPEED = 150
const knockback_points = [
	Vector2(0.41, -1.65),
	Vector2(1.22, -1.60),
	Vector2(1.99, -1.51),
	Vector2(2.71, -1.38),
	Vector2(3.36, -1.22),
	Vector2(3.91, -1.01),
	Vector2(4.36, -0.79),
	Vector2(4.69, -0.54),
	Vector2(4.89, -0.27),
	Vector2(4.95, 0.00),
	Vector2(4.89, +0.27),
	Vector2(4.69, +0.54),
	Vector2(4.36, +0.79),
	Vector2(3.91, +1.01),
	Vector2(3.36, +1.22),
	Vector2(2.71, +1.38),
	Vector2(1.99, +1.51),
	Vector2(1.22, +1.60),
	Vector2(0.41, +1.65),
]
var target;
var i = -1;
var direction;

var knockback = false	
var health = 100
var damage = 10

@onready var player = $"../player"
@onready var timer = $DamageTimer

@onready var r_detector = $Right_Player_Detector
@onready var l_detector = $Left_Player_Detector
@onready var r_gdetector = $right_ground_detector
@onready var l_gdetector = $left_ground_detector

var player_in_range = null # playerul este în range
var damage_interval = 0.1  # Intervalul de timp între aplicarea daunelor (în secunde)
var last_damage_time = 0.0  # Momentul în care s-a aplicat ultima dată daune

var moving_distance;
var moving_speed;

var random_direction = 0
var random_move_timer = 0.0
var random_move_interval = 2.0
var sees_player;
var not_on_ground;
var anim_flag;

var wait_time = true;
func _ready() -> void:
	$EnemyHealthBar.value = health
	
func go_left(s):
	SPEED = s
	velocity.x = - SPEED
	if not anim_flag:
		$Animatii.flip_h = false
		$Animatii.play("run")
		
func go_right(s):
	SPEED = s
	velocity.x = SPEED
	if not anim_flag:
		$Animatii.flip_h = true
		$Animatii.play("run")
		

func _process(delta):
	
	#print(check_cliff_edge())
	#not_on_ground = l_gdetector.is_colliding() or r_gdetector.is_colliding()
	#if(not r_gdetector.is_colliding()):
		#go_left(10)
#
	#
	#if(not_on_ground):
		#l_gdetector.get_collider()
		#r_gdetector.get_collider()
		#velocity.x = 0
		#if $Animatii.animation == "run":
			#$Animatii.stop()
			#print("stopped")
		#
	# daca nu detecteaza nimic atunci se misca random
	# Detectăm dacă vedem playerul
	sees_player = r_detector.is_colliding() or l_detector.is_colliding()

	if sees_player:
		# Mergem spre player
		var direction_to_player = sign(player.global_position.x - global_position.x)
		if direction_to_player == -1 :
			go_left(10)
		else:
			go_right(10)
	else:
		if wait_time:
			random_direction = [-1, 0, 1][randi() % 3] # aleator stânga, dreapta sau stă
			if random_direction == -1:
				go_left(randi_range(10, 40))
			if random_direction == 0:
				$Animatii.play("default")
				velocity.x = 0
			if random_direction == 1:
				go_right(randi_range(10, 40))
			wait_time = false
			$change_timer.start()
			
		
			 
	#else:
		## Mișcare aleatorie
		#random_move_timer += delta
		#if random_move_timer >= random_move_interval:
			#random_direction = [-1, 0, 1][randi() % 3] # aleator stânga, dreapta sau stă
			#random_move_timer = 0.0
		#
		#velocity.x = random_direction * SPEED
		#if random_direction != 0:
			#$Animatii.flip_h = random_direction < 0
		#if not anim_flag:
			#$Animatii.play("run")

		
	if not $Animatii.is_playing() and health:
		$Animatii.play("default")
		
	if not is_on_floor():
		velocity += get_gravity() * delta
		#
	if player_in_range :
		last_damage_time += delta # pentru a primi damage in mod controlat la 1sec
		$Animatii.play("Attack")
		if last_damage_time >= damage_interval:
			_on_damage_timer_timeout()
			last_damage_time = 0.0
			
	# de adaugat incetinire
	if knockback:

		if i < knockback_points.size():
			if direction > 0 :
				global_position = global_position + knockback_points[i] 
			else:
				global_position.x = global_position.x + knockback_points[i].x * (-1) 
				global_position.y = global_position.y + knockback_points[i].y  

			i += 1
		else:
			knockback = false
			i = 0
		
	move_and_slide()


func take_damage(amount, facing):	
	anim_flag = true;
	# luam partea din care ataca jucatorul
	# facing = 1 ->  
	print(facing)
	health -= amount
	$EnemyHealthBar.value = health
	direction = facing
	if facing == 1:
		$Animatii.flip_h = false
		$Animatii.play("attacked")
		knockback = true
	else:
		$Animatii.flip_h = true
		$Animatii.play("attacked")
		knockback = true
		await get_tree().create_timer(0.5).timeout
		$Animatii.flip_h = false
		
	if health <= 0:
		if facing == 1:
			$Animatii.flip_h = false
			$Animatii.play("death")
			await get_tree().create_timer(0.8).timeout
		else:
			$Animatii.flip_h = true
			$Animatii.play("death")
			await get_tree().create_timer(0.8).timeout # asteptam sa isi faca animatia
			$Animatii.flip_h = false
		
		die()
	await get_tree().create_timer(0.08).timeout # asteptam sa isi faca animati
	anim_flag = false
	knockback = false
	
func die():
	print("Inamicul a murit!")
	queue_free()

func _on_body_entered(body):
	if body.name == "player":
		player_in_range = body
		print("Player detectat!")

func _on_body_exited(body):
	if body.name == "player":
		player_in_range = null
		print("Player ieșit din zonă!")

# Damage în buclă cât timp jucătorul e în zonă
func _on_damage_timer_timeout():
	if player_in_range:
		player_in_range.take_damage(damage)
		
func check_cliff_edge() -> int:
	var left_ground = $left_ground_detector.is_colliding()
	var right_ground = $right_ground_detector.is_colliding()
	if not right_ground and left_ground:
		return 1  # marginea din dreapta
	elif not left_ground and right_ground:
		return -1  # marginea din stânga
	else:
		return 0  # e pe mijloc sau în aer complet


func _on_change_timer_timeout() -> void:
	wait_time = true;
