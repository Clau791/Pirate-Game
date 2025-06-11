extends GutTest

class DummyEnemy:
	extends Node
	var last_damage_amount: int = 0
	var last_damage_facing: int = 0

	func take_damage(amount: int, facing_dir: int) -> void:
		last_damage_amount = amount
		last_damage_facing = facing_dir

class DummyPlayer:
	extends Node
	var picked_up_sword: bool = false

	func pickup_sword() -> void:
		picked_up_sword = true

class MockSword:
	extends "res://scrips/Sword.gd"

	func _ready() -> void:
		pass

func test_body_entered_on_enemy_take_damage() -> void:
	var sword := MockSword.new()
	add_child(sword)

	var enemy := DummyEnemy.new()
	enemy.name = "dummy_enemy"
	add_child(enemy)
	enemy.add_to_group("Enemies")
	sword.add_child(enemy)

	sword.damage = 42
	sword.facing = 1

	sword.body_entered(enemy)

	assert_eq(enemy.last_damage_amount, 42,
		"take_damage(...) should have received damage = 42.")
	assert_eq(enemy.last_damage_facing, 1,
		"take_damage(...) should have received facing = 1.")

func test_body_entered_on_player_canPickUp_true() -> void:
	var sword := MockSword.new()
	add_child(sword)

	var player := DummyPlayer.new()
	player.name = "player"
	add_child(player)
	player.add_to_group("player")
	sword.add_child(player)

	assert_false(sword.canPickUp, "Initially, canPickUp should be false.")
	sword.body_entered(player)

	assert_true(sword.canPickUp,
		"After body_entered(...) with player, canPickUp should become true.")

func test_body_exited_on_player_canPickUp_false() -> void:
	var sword := MockSword.new()
	add_child(sword)

	var player := DummyPlayer.new()
	player.name = "player"
	player.add_to_group("player")
	add_child(player)

	sword.canPickUp = true

	sword.body_exited(player)

	assert_false(sword.canPickUp,
		"body_exited(...) with body.is_in_group('player') should set canPickUp = false.")

func test_process_sets_linear_velocity() -> void:
	var sword := MockSword.new()
	add_child(sword)

	assert_eq(sword.direction, Vector2.RIGHT, "direction implicit = (1, 0).")
	assert_eq(sword.SPEED, 1000, "SPEED implicit = 1000.")

	sword._process(0.016)

	assert_eq(sword.linear_velocity, Vector2.RIGHT * 1000,
	"_process should set linear_velocity = direction * SPEED.")
	assert_true(abs(sword.SPEED - 960.0) < 0.001,
		"_process should reduce SPEED to 960 (1000 * 0.96).")

func test_on_down_embedded_body_entered() -> void:
	var sword := MockSword.new()
	add_child(sword)

	var wall := Node2D.new()
	wall.name = "Wall"
	sword.add_child(wall)

	assert_false(sword.down_embadded, "Initially, down_embadded should be false.")

	sword._on_down_embdden_body_entered(wall)

	assert_true(sword.down_embadded,
		"_on_down_embdden_body_entered(...) should set down_embadded = true.")


func test_no_gravity() -> void:
	var sword := MockSword.new()
	add_child(sword)

	assert_true(abs(sword.gravity_scale - 1) < 0.0001,
		"Default gravity_scale should be 1.")

	sword.no_gravity() 

	assert_eq(sword.gravity_scale, 0,
		"no_gravity() should set `gravity_scale = 0`.")
