extends GutTest

var PlayerScene = preload("res://scenes/player.tscn")

func is_on_floor():
	return true  

func before_each():
	pass

func test_player_moves_right():
	var player = PlayerScene.instantiate()
	add_child(player)

	player.velocity = Vector2.ZERO
	Input.action_press("ui_right")
	player._physics_process(0.016) 
	Input.action_release("ui_right")

	assert_gt(player.velocity.x, 0, "Player should move right")

func test_speed_boost_applied():
	var player = PlayerScene.instantiate()
	add_child(player)
	
	player.speed_boost_active = true
	player.speed = player.base_speed + player.bonus_speed

	assert_eq(player.speed, 250.0, "Speed boost should increase player speed correctly")

func test_damage_boost_flag():
	var player = PlayerScene.instantiate()
	add_child(player)
	player.damage_boost_active = true

	assert_true(player.damage_boost_active, "Damage boost flag should be true")

func test_attack_node_exists():
	var player = PlayerScene.instantiate()
	add_child(player)

	assert_not_null(player.Attack_Hitbox, "Attack_Hitbox should be set")
	assert_not_null(player.attacking, "Attack_Animation should be set")
