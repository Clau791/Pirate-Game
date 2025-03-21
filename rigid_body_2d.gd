extends RigidBody2D

@onready var animation = $AnimatedSprite2D
@onready var collision_shape_2d = $CollisionShape2D
@onready var area = $Area2D

var SPEED = 1000
var direction = Vector2.RIGHT
var damage = 10
var isPickedUp := false
var canPickUp := false

func _ready() -> void:
	# Sabia începe dezactivată și "înghețată"
	freeze = true
	gravity_scale = 1
	collision_shape_2d.disabled = true

	
# Aplică impulsul la aruncare
func throw_sword(t_direction: Vector2):
	direction = t_direction.normalized()
	#rotation = direction.angle()  # Rotate sword to face direction
	freeze = false
	animation.play("throw")
	collision_shape_2d.disabled = false
	set_linear_velocity(direction * SPEED)
# Detectează dacă player-ul e lângă sabie
func body_entered(body):
	
	if body.is_in_group("Enemies"):
		body.take_damage(damage)
		
	if body.name == "player":
		print("sword picked up")
		canPickUp = true
		
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
	SPEED = SPEED * 0.95
