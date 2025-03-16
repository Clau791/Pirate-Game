extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -400.0
const CLIMB_SPEED = 150

var health = 50
var damage = 10

@onready var timer = $DamageTimer

var player_in_range = null # playerul este în range

var damage_interval = 0.1  # Intervalul de timp între aplicarea daunelor (în secunde)
var last_damage_time = 0.0  # Momentul în care s-a aplicat ultima dată daune

func _ready() -> void:
	$EnemyHealthBar.value = health
	
func _process(delta):
	
	#if not is_on_floor():
		#velocity += get_gravity() * delta
		#
	if player_in_range :
		last_damage_time += delta # pentru a primi damage in mod controlat la 1sec
		if last_damage_time >= damage_interval:
			_on_damage_timer_timeout()
			last_damage_time = 0.0
	#move_and_slide()
	
func take_damage(amount):
	health -= amount
	$EnemyHealthBar.value = health
	if health <= 0:
		die()

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
