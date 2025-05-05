extends CharacterBody2D

const SPEED = 150.0
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

var player_in_range = null # playerul este în range
var damage_interval = 0.1  # Intervalul de timp între aplicarea daunelor (în secunde)
var last_damage_time = 0.0  # Momentul în care s-a aplicat ultima dată daune

func _ready() -> void:
	$EnemyHealthBar.value = health
	

func _process(delta):
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
	# luam partea din care ataca jucatorul
	# facing = 1 ->  
	print(facing)
	health -= amount
	$EnemyHealthBar.value = health
	direction = facing
	if facing == 1:
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
			$Animatii.play("death")
			await get_tree().create_timer(0.8).timeout
		else:
			$Animatii.flip_h = true
			$Animatii.play("death")
			await get_tree().create_timer(0.8).timeout # asteptam sa isi faca animatia
			$Animatii.flip_h = false
		
		die()
	await get_tree().create_timer(0.08).timeout # asteptam sa isi faca animati
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
