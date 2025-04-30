extends Control

func _on_nivel1_button_pressed():
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_nivel2_button_pressed():
	get_tree().change_scene_to_file("res://scenes/new_level.tscn")

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://MainMenu.tscn")
