extends Node2D

@export var cloud1 = preload("res://scenes/cloud1.tscn")
@export var cloud2 = preload("res://scenes/cloud2.tscn")
@export var cloud3 = preload("res://scenes/cloud3.tscn")
var clouds = [cloud1, cloud2, cloud3]
var clouds_on_screen = []

var random; 
var y;

# se genereaza de la pozitia de start undeva unde userul nu vede posibil in perete
func Cloud_Timer():
	generate_cloud(-100) # 3700, -100
	
# Called when the node enters the scene tree for the first time.
func generate_cloud(x):
	#generam un nor la intamplare
	random = randi_range(0, 2)
	var new_cloud = clouds[random].instantiate()
	y = randf_range(-70, -255) # se da inaltimea adecvata
	new_cloud.global_position = Vector2(x,y)
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
	$cannon2.scale.x = -1
	$Cloud_Timer.start()
	# generam 10 nori random in scena 
	for i in range(9):
		random = randi_range(4000,5000) # pozitia norilor generati la incarcarea scenei pe ox
		generate_cloud(random)
		
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
