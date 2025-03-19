extends RigidBody2D

@onready var animation = $AnimatedSprite2D
@onready var collision_shape_2d = $CollisionShape2D
@onready var area = $Area2D

var damage = 10
var isPickedUp := false
var canPickUp := false

func _ready() -> void:
	# Sabia începe dezactivată și "înghețată"
	freeze = true
	gravity_scale = 1
	collision_shape_2d.disabled = true
	



# Aplică impulsul la aruncare
func throw_sword(direction: Vector2):
	
	freeze = false
	linear_velocity = direction
	animation.play("throw")
	collision_shape_2d.disabled = false

# Detectează dacă player-ul e lângă sabie
func body_entered(body):
	
	if body.is_in_group("Enemies"):
		body.take_damage(damage)
		
	if body.name == "player":
		print("sword picked up")
		canPickUp = true
		
func body_exited(body):
	if body.is_in_group("player"):
		canPickUp = false

# Când e ridicată, sabia dispare și player-ul o "primește înapoi"
func _process(_delta):
	if Input.is_action_just_pressed("pickup"):
		print("tried to pick up")
		
	if linear_velocity.length() < 1 :
		animation.stop()
		
	if canPickUp and Input.is_action_just_pressed("pickup"):
		var player = get_tree().get_first_node_in_group("player")
		player.pickup_sword()
		queue_free()  # Distruge sabia fizică
