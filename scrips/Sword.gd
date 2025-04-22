extends RigidBody2D

@onready var animation = $AnimatedSprite2D
@onready var collision_shape_2d = $CollisionShape2D
@onready var area = $Throwing_area
@onready var embedden_test = $SIDE_EMBEDDEN

var SPEED = 1000
var direction = Vector2.RIGHT
var damage = 10
var isPickedUp := false
var canPickUp := false
var facing;
var side_embadded = false;
var down_embadded = false;
func _ready() -> void:
	# Sabia începe dezactivată și "înghețată"
	freeze = true
	gravity_scale = 1
	collision_shape_2d.disabled = true

	
# Aplică impulsul la aruncare
func throw_sword(t_direction: Vector2):
	facing = t_direction[0];
	direction = t_direction.normalized()
	#rotation = direction.angle()  # Rotate sword to face direction
	freeze = false
	animation.play("throw")
	collision_shape_2d.disabled = false
	set_linear_velocity(direction * SPEED)
# Detectează dacă player-ul e lângă sabie
func body_entered(body):
	
	if body.is_in_group("Enemies"):
		body.take_damage(damage,facing)
		
	if body.name == "player":
		print("sword picked up")
		canPickUp = true
		
	# pentru a intra in block , cream inca un hitbox pe alt layer si pentru cel actual
	# schimbam mask pentru a nu interactiona
		
		
func body_exited(body):
	if body.is_in_group("player"):
		print("exited")
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
	SPEED = SPEED * 0.96
	
	# se loveste de zid si ramane acolo
	if(abs(SPEED) > 50 and SPEED != 0 and side_embadded):
		print(SPEED)
		set_global_rotation(0)
		area.change_mask()
		if facing == -1:
			rotation = 3;# roteste 3 pi  
		SPEED = 0
		no_gravity()
		
		animation.play("Embedded")
		$Animation_Stop.start();
		#pozitie fixa infipt in perete fara gravitatie
	
	if(abs(SPEED) < 0.5 and SPEED != 0 and down_embadded): # speed diferit de 0 pentru a nu se face bucla
		set_global_rotation(0)
		area.change_mask()
		rotation = 2 # se infige in pamant
		SPEED = 0 ;
		animation.play("Embedded")
		$Animation_Stop.start();
		
		#no_gravity()
		#test
		
		

	# determinat pozitia actuala, unde priveste player ul cand a aruncat !!! determina cum se 
	# infige sabia
	# daca este oprit cu o viteza mare de un perete determinam directia si facem flip
	
	# idee !! : daca direction e negativ inseamna ca da spre stanga deci facem flip

		 
func no_gravity():
	gravity_scale = 0;


func _on_side_embedden_body_entered(body: Node2D) -> void:
	side_embadded = true;

func stop_animation():
	animation.stop()


func _on_down_embdden_body_entered(body: Node2D) -> void:
	down_embadded = true


func _on_down_embdden_body_exited(body: Node2D) -> void:
	down_embadded = false
