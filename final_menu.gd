extends Control

@onready var replay_button = $HBoxContainer/Replay
@onready var next_button = $"HBoxContainer/Next Level"

func _on_replay_pressed() -> void:
	if get_tree().current_scene.name == "PirateIsland":
		get_tree().change_scene_to_file("res://scenes/pirate_island.tscn")
	elif get_tree().current_cene.name == "Level2":
		get_tree().change_scene_to_file("res://scenes/Level_2.tscn")
	
func _on_next_level_pressed() -> void:
	if get_tree().current_scene.name == "PirateIsland":
		get_tree().change_scene_to_file("res://scenes/Level_2.tscn")
	elif get_tree().current_cene.name == "Level2":
		get_tree().change_scene_to_file("res://scenes/pirate_island.tscn")
