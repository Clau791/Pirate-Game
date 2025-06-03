extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -400.0

var target;
var i = -1;
var direction;

var knockback = false	
var health = 100
var damage = 10
@onready var player = $"../player"
@onready var timer = $DamageTimer
@export var shooter_projectile = preload("res://scenes/shooter_projectile.tscn")  # Scena sabiei fizice


var player_in_range = null # playerul este în range
var can_shoot = true # Intervalul de timp între aplicarea daunelor (în secunde)
var last_damage_time = 0.0  # Momentul în care s-a aplicat ultima dată daune

func _ready() -> void:
	$EnemyHealthBar.value = health
	

func _process(delta):
	if can_shoot and $player_Detector.is_colliding() :
		$Animatii.play("Attack")

		var s = shooter_projectile.instantiate()
		s.global_position = global_position + Vector2(-4, 8)
		s.shoot($Animatii.flip_h)
		get_parent().add_child(s)
		can_shoot = false
		
		

	if not $Animatii.is_playing() and health:
		$Animatii.play("default")
		
	if not is_on_floor():
		velocity += get_gravity() * delta
		
		
		
	move_and_slide()


func take_damage(amount, facing):	
	# luam partea din care ataca jucatorul
	# facing = 1 ->  
	print("take damage")
	health -= amount
	$EnemyHealthBar.value = health
	direction = facing
	if facing == 1:
		$Animatii.play("attacked")
	else:
		$Animatii.play("attacked")
		await get_tree().create_timer(0.5).timeout
		
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
	
	
func die():
	print("Inamicul a murit!")
	player.increase_score(300)
	queue_free()


# Damage în buclă cât timp jucătorul e în zonă
func _on_damage_timer_timeout():
	can_shoot = true
