extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -400.0

var target;
var direction;

var knockback = false	
var health = 100
var damage = 40
@onready var player = $"../player"
@export var shooter_projectile = preload("res://scenes/cannon_ball.tscn")  # Scena sabiei fizice

var can_shoot = true # Intervalul de timp între aplicarea daunelor (în secunde)

func _ready() -> void:
	$EnemyHealthBar.value = health
	

func _process(delta):

		
	if can_shoot and $player_Detector.is_colliding() :
		$Animatii.play("attack")
		
		
		$shot_effect.visible = true
		$shot_effect.play("default")
		
		var s = shooter_projectile.instantiate()
		s.global_position = global_position
		
		var direction_x = player.global_position.x - $player_Detector.global_position.x
		if direction_x < 0:
			s.shoot(false)
			print("false")
		elif direction_x > 0:
			s.shoot(true)
			print("true")
		get_parent().add_child(s)
		can_shoot = false
		

	if not $Animatii.is_playing() and health:
		$Animatii.play("idle")
		
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

func _on_shot_effect_animation_finished() -> void:
	$shot_effect.visible = false 


func _on_timer_timeout() -> void:
	can_shoot = true
