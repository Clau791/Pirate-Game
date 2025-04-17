extends Node2D

@export var cloud1 = preload("res://scenes/cloud1.tscn")
@export var cloud2 = preload("res://scenes/cloud2.tscn")
@export var cloud3 = preload("res://scenes/cloud3.tscn")
var clouds = [cloud1, cloud2, cloud3]
var clouds_on_screen = []

var random; 
var y;

# Called when the node enters the scene tree for the first time.
func generate_cloud():
	#generam un nor la intamplare
	random = randi_range(0, 2)
	var new_cloud = clouds[random].instantiate()
	y = randf_range(-10, -55)
	new_cloud.global_position = Vector2(-100,y)
	add_child(new_cloud)
	if clouds_on_screen.size() <= 20:
		clouds_on_screen.append(new_cloud)
	else:
		delete_cloud(clouds_on_screen[0])
		clouds_on_screen.pop_at(0)
		clouds_on_screen.append(clouds[random])
		
func delete_cloud(c):
	c.queue_free()

func _ready() -> void:
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
