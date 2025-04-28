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
	pass
	
# Aplică impulsul la aruncare
func throw_sword(t_direction: Vector2):
	print(t_direction)
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
		#print("sword picked up")
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
	if(side_embadded and abs(SPEED) > 80 and SPEED != 0 ):
		print("side_embadded", SPEED)

		SPEED = 0
		set_global_rotation(0)
		area.change_mask() #schimbam sabia in sabie rupta
		
		if facing < 0:
			rotation = 3;# roteste 3 pi  
		no_gravity()
		
		animation.play("Embedded")
		$Animation_Stop.start();
		print(rotation)

		#pozitie fixa infipt in perete fara gravitatie
	
	if(down_embadded and abs(SPEED) < 0.5 and SPEED != 0): # speed diferit de 0 pentru a nu se face bucla
		
		SPEED = 0 ;
		rotation = 2 # se infige in pamant
		print(rotation)
		animation.play("Embedded")
		$Animation_Stop.start();
		area.change_mask()
		print("down_embadded")
		

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
