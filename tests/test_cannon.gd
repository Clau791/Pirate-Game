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

class DummyShotEffect:
	extends Node
	var visible: bool = false
	var last_played: String = ""

	func play(anim_name: String) -> void:
		last_played = anim_name

class DummyPlayer:
	extends Node
	var score: int = 0
	func increase_score(amount: int) -> void:
		score += amount

class MockCannon:
	extends "res://scrips/cannon.gd"

	func _ready() -> void:
		pass

func test_ready_default_health() -> void:
	var cannon := MockCannon.new()
	add_child(cannon)

	var health_bar := DummyHealthBar.new()
	health_bar.name = "EnemyHealthBar"
	cannon.add_child(health_bar)

	cannon._ready()

	assert_eq(health_bar.value, cannon.health,
		"In _ready(), cannon should write `health` in EnemyHealthBar.value.")

func test_on_timer_resets_shoot() -> void:
	var cannon := MockCannon.new()
	add_child(cannon)

	cannon.can_shoot = false
	cannon._on_timer_timeout()
	assert_true(cannon.can_shoot,
		"_on_timer_timeout() should have set can_shoot = true.")


func test_take_damage_health_updates_healthbar() -> void:
	var cannon := MockCannon.new()
	add_child(cannon)

	var health_bar := DummyHealthBar.new()
	health_bar.name = "EnemyHealthBar"
	cannon.add_child(health_bar)

	var anim := DummyAnim.new()
	anim.name = "Animatii"
	cannon.add_child(anim)

	var dummy_player := DummyPlayer.new()
	cannon.player = dummy_player
	add_child(dummy_player)

	cannon.health = 70
	cannon.direction = 0
	cannon.can_shoot = false

	cannon.take_damage(30, 1)

	assert_eq(cannon.health, 40,
		"After take_damage(30,1) health should have gone from 70 to 40.")
	assert_eq(health_bar.value, 40,
		"EnemyHealthBar.value should be 40.")
	assert_eq(cannon.direction, 1,
		"Direction should have been 1 after call facing=1.")
	assert_eq(anim.last_played, "attacked",
		"Should have run animation anim.play('attacked').")
	assert_eq(dummy_player.score, 0,
		"Die() should not be called when health > 0, score doesnt modify")

func test_on_animation_finished_sets_visibility_false() -> void:
	var cannon := MockCannon.new()
	add_child(cannon)

	var shot_effect := DummyShotEffect.new()
	shot_effect.name = "shot_effect"
	shot_effect.visible = true  
	cannon.add_child(shot_effect)

	cannon._on_shot_effect_animation_finished()

	assert_false(shot_effect.visible,
		"_on_shot_effect_animation_finished() should set shot_effect.visible = false.")
