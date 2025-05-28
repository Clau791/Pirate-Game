extends RigidBody2D

@onready var animation = $AnimatedSprite2D
@onready var up_animation = $Up_Sprite

@onready var collision_shape_2d = $CollisionShape2D
@onready var area = $Throwing_area

var SPEED = 1000
var direction = Vector2.RIGHT
var damage = 30



func _ready() -> void:


	$Destroy_timer.start()
	
# Aplică impulsul la aruncare
func shoot(facing: bool):
	direction =Vector2(-1, 0)
	if facing :
		direction = Vector2(1,0)
		

func _process(delta):	
	$AnimatedSprite2D.z_index = -100 #nu se vede
	await get_tree().create_timer(0.5).timeout  # așteaptă 0.5 secunde
	$AnimatedSprite2D.z_index = 10 #nu se vede

	global_position = global_position + direction
	#if(down_embadded and abs(SPEED) < 2 and SPEED != 0 ): # speed diferit de 0 pentru a nu se face bucla 
		#print("down")
		#SPEED = 0 ;
		#
		#area.change_mask()
#
		#rotation = PI / 2 # se infige in pamant
#
		#animation.play("Embedded")
		#await get_tree().create_timer(0.8).timeout
		#animation.stop()
	

	
func _on_destroy_timer_timeout() -> void:
	$AnimatedSprite2D.play("destroyed")
	direction = Vector2(0,0)
	await get_tree().create_timer(0.5).timeout

	queue_free()
	

func _on_body_entered(body) -> void:
	if body.is_in_group("player"):
		body.take_damage(damage)
	# daca a murit oprim proiectilele

	$AnimatedSprite2D.play("destroyed")
	if not body.is_dead() :
		await get_tree().create_timer(0.5).timeout

	queue_free()
