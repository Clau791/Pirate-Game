extends Area2D

var target_scene = "res://new_level.tscn"  # Calea către următorul nivel

func _ready() -> void:
	connect("body_entered", _on_body_entered)
	
func _on_body_entered(body):
	#easy teleport
	if body.name =="player":
		get_tree().change_scene_to_file("res://scenes/new_level.tscn")
		
			#Apelăm funcția de tranziție din CanvasLayer
	#var canvas_layer = get_node("../CanvasLayer") # Adjust path based on your node hierarchy
	#await canvas_layer.start_transition_to_scene(target_scene)
