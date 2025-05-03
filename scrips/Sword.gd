extends RigidBody2D

@onready var animation = $AnimatedSprite2D
@onready var up_animation = $Up_Sprite

@onready var collision_shape_2d = $CollisionShape2D
@onready var area = $Throwing_area

var SPEED = 1000
var direction = Vector2.RIGHT
var damage = 10
var isPickedUp := false
var canPickUp := false
var facing;

var right_embadded = false;
var down_embadded = false;
var left_embadded = false;
var up_embadded = false;
var falling = false;

func _ready() -> void:
	pass
	
# Aplică impulsul la aruncare
func throw_sword(t_direction: Vector2):
	facing = t_direction[0];
	direction = t_direction.normalized()

	animation.play("throw")
	
	set_linear_velocity(direction * SPEED)
	
# Detectează dacă player-ul e lângă sabie
func body_entered(body):
	
	if body.is_in_group("Enemies"):
		body.take_damage(damage,facing)
		
	if body.name == "player":
		#print("sword picked up")
		canPickUp = true
		
	# pentru a intra in block , cream inca un hitbox pe alt layer si pentru cel actual
	# schimbam mask pentru a nu interactiona
		
		
func body_exited(body):
	if body.is_in_group("player"):
		canPickUp = false

# Când e ridicată, sabia dispare și player-ul o "primește înapoi"
func _input(event):
	if canPickUp and event.is_action_pressed("pickup"):
		var player = get_tree().get_first_node_in_group("player")
		if player:
			canPickUp = false
			player.pickup_sword()
			queue_free()
			

func _process(delta):	
	
	set_linear_velocity(direction * SPEED)
	SPEED = SPEED * 0.96 # incetinire
	if(down_embadded and abs(SPEED) < 2 and SPEED != 0 ): # speed diferit de 0 pentru a nu se face bucla 
		print("down")
		SPEED = 0 ;
		
		area.change_mask()

		rotation = PI / 2 # se infige in pamant

		animation.play("Embedded")
		await get_tree().create_timer(0.8).timeout
		animation.stop()
	
		
	# determinat pozitia actuala, unde priveste player ul cand a aruncat !!! determina cum se 
	# infige sabia
	# daca este oprit cu o viteza mare de un perete determinam directia si facem flip
	
	# idee !! : daca direction e negativ inseamna ca da spre stanga deci facem flip

		 
func no_gravity():
	gravity_scale = 0;



func _on_down_embdden_body_entered(body: Node2D) -> void:
	down_embadded = true
	

		

func _on_right_embadded_body_entered(body: Node2D) -> void:
	right_embadded = true
	
	if(right_embadded and abs(SPEED) > 150 and SPEED != 0 ):
		print("right")
		SPEED = 0

		area.change_mask() #schimbam sabia in sabie rupta
		
		no_gravity()
		
		animation.play("Embedded")
		
		await get_tree().create_timer(0.8).timeout
		animation.stop()

func _on_left_embadde_body_entered(body: Node2D) -> void:
	left_embadded = true
	
	if(left_embadded and abs(SPEED) > 150 and SPEED != 0 ):
		print("left")
		SPEED = 0
		area.change_mask() #schimbam sabia in sabie rupta
		
		no_gravity()
		animation.flip_h = true
		animation.play("Embedded")
		await get_tree().create_timer(0.8).timeout
		animation.stop()

func _on_up_embadde_body_entered(body: Node2D) -> void:
	
		# se loveste de zid si ramane acolo
	if(abs(SPEED) > 180 and SPEED != 0 ):
		down_embadded = false
		left_embadded = false
		right_embadded = false
		SPEED = 0
		print("up")
		
		
		area.change_mask() #schimbam sabia in sabie rupta
		
		no_gravity()
		animation.play("UP-EMBADDED")
		await get_tree().create_timer(0.8).timeout
		animation.stop()
		await get_tree().create_timer(5).timeout # dupa 5 secunde cade
		animation.play("throw")
		gravity_scale = 1
		direction = Vector2(0, 1)
		SPEED = 200


		#down_embadded = false # ne asiguram ca nu se fixeaza din nou in tavan
		#await get_tree().create_timer(0.5).timeout # dupa 5 secunde cade
		#falling = true
