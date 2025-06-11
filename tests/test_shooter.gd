extends GutTest

class DummyHealthBar:
	extends Node
	var value: int = 100

class DummyAnim:
	extends Node
	var flip_h: bool = false
	var last_played: String = ""

	func play(anim_name: String) -> void:
		last_played = anim_name

class DummyPlayer:
	extends Node
	var score: int = 0
	func increase_score(amount: int) -> void:
		score += amount

class MockShooter:
	extends "res://scrips/shooter.gd"

	func _ready() -> void:
		bar = 100

func test_ready_sets_healthbar_to_default_health() -> void:
	var shooter := MockShooter.new()
	add_child(shooter)

	var health_bar := DummyHealthBar.new()
	health_bar.name = "EnemyHealthBar"
	shooter.add_child(health_bar)

	shooter._ready()
	print(shooter.health)
	print(health_bar.value)
	assert_eq(health_bar.value, shooter.health,
		"In _ready(), EnemyHealthBar.value should equal the default value of `health` (i.e. 100).")


func test_on_damage_timer_timeout_resets_can_shoot() -> void:
	var shooter := MockShooter.new()
	add_child(shooter)

	shooter.can_shoot = false
	shooter._on_damage_timer_timeout()
	assert_true(shooter.can_shoot,
		"_on_damage_timer_timeout() should set can_shoot = true.")


func test_take_damage_non_lethal_reduces_health_and_updates_healthbar() -> void:
	var shooter := MockShooter.new()
	add_child(shooter)

	var health_bar := DummyHealthBar.new()
	health_bar.name = "EnemyHealthBar"
	shooter.add_child(health_bar)

	var anim := DummyAnim.new()
	anim.name = "Animatii"
	shooter.add_child(anim)

	var dummy_player := DummyPlayer.new()
	shooter.player = dummy_player
	add_child(dummy_player)

	shooter.health = 50
	shooter.direction = 0
	shooter.can_shoot = false

	shooter.take_damage(10, 1)

	assert_eq(shooter.health, 40,
		"After take_damage(10,1) health should be 40.")
	assert_eq(health_bar.value, 40,
		"EnemyHealthBar.value should be updated to 40.")
	assert_eq(shooter.direction, 1,
		"Direction should be set to 1.")
	assert_eq(anim.last_played, "attacked",
		"In the non-lethal case, anim.play('attacked') should be called.")
	assert_eq(dummy_player.score, 0,
		"Die() should not be called when health > 0. The player's score remains 0.")
