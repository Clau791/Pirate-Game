extends GutTest

class DummyHealthBar:
	extends Node
	var value: float = 0

class DummyAnim:
	extends Node
	var flip_h: bool = false
	var last_played: String = ""

	func play(anim_name: String) -> void:
		last_played = anim_name

class DummyDetector:
	extends Node
	var colliding: bool = false
	func is_colliding() -> bool:
		return colliding

class DummyBody:
	extends Node

class MockEnemy:
	extends "res://scrips/Enemy.gd"

	func _ready() -> void:
		pass

func test_take_damage_health_knockback_attacked_animation() -> void:
	var enemy := MockEnemy.new()
	add_child(enemy)

	var health_bar := DummyHealthBar.new()
	health_bar.name = "EnemyHealthBar"
	enemy.add_child(health_bar)

	var anim := DummyAnim.new()
	anim.name = "Animatii"
	enemy.add_child(anim)

	enemy.health = 50
	enemy.direction = 0
	enemy.knockback = false

	enemy.take_damage(10, 1)

	assert_eq(enemy.health, 40, "Health should decrease by 10 (from 50 to 40).")
	assert_eq(health_bar.value, 40, "EnemyHealthBar.value was not updated correctly.")
	assert_eq(enemy.direction, 1, "Enemy direction should be 1.")
	assert_true(enemy.knockback, "Knockback should be true after being attacked.")
	assert_false(anim.flip_h, "flip_h should be false when facing == 1.")
	assert_eq(anim.last_played, "attacked", "It should play the 'attacked' animation.")


func test_check_cliff_edge_minus_one() -> void:
	var enemy := MockEnemy.new()
	add_child(enemy)

	var left_det := DummyDetector.new()
	left_det.name = "left_ground_detector"
	left_det.colliding = false 
	enemy.add_child(left_det)

	var right_det := DummyDetector.new()
	right_det.name = "right_ground_detector"
	right_det.colliding = true  
	enemy.add_child(right_det)

	enemy.direction = -1
	assert_true(enemy.check_cliff_edge(),
		"For direction == -1 and left_detector.colliding = false, check_cliff_edge() should return true.")


func test_check_cliff_edge_one() -> void:
	var enemy := MockEnemy.new()
	add_child(enemy)

	var left_det := DummyDetector.new()
	left_det.name = "left_ground_detector"
	left_det.colliding = true  
	enemy.add_child(left_det)

	var right_det := DummyDetector.new()
	right_det.name = "right_ground_detector"
	right_det.colliding = false 
	enemy.add_child(right_det)

	enemy.direction = 1
	assert_true(enemy.check_cliff_edge(),
		"For direction == 1 and right_detector.colliding = false, check_cliff_edge() should return true.")


func test_check_cliff_edge_no_cliff() -> void:
	var enemy := MockEnemy.new()
	add_child(enemy)

	var left_det := DummyDetector.new()
	left_det.name = "left_ground_detector"
	left_det.colliding = true
	enemy.add_child(left_det)

	var right_det := DummyDetector.new()
	right_det.name = "right_ground_detector"
	right_det.colliding = true
	enemy.add_child(right_det)

	enemy.direction = -1
	assert_false(enemy.check_cliff_edge(),
		"If both detectors are on ground regardless of direction, it should return false.")

func test_on_body_entered_in_range() -> void:
	var enemy := MockEnemy.new()
	add_child(enemy)

	var body := DummyBody.new()
	body.name = "player"

	enemy._on_body_entered(body)
	assert_true(enemy.player_in_range == body,
		"_on_body_entered(body) with body.name = 'player' should set player_in_range = body.")


func test_on_body_exited_in_range() -> void:
	var enemy := MockEnemy.new()
	add_child(enemy)
	
	var body := DummyBody.new()
	body.name = "player"
	enemy.player_in_range = body

	enemy._on_body_exited(body)
	assert_true(enemy.player_in_range == null,
		"_on_body_exited(body) with body.name = 'player' should set player_in_range = null.")
