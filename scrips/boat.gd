extends Control

@onready var ship = $Ship
@onready var catarg = $Catarg
var original_ship_y = 0.0
var original_catarg_y = 0.0
var amplitude = 1
var speed = 7

func _ready():
	original_ship_y = ship.position.y
	original_catarg_y = catarg.position.y

func _process(delta):
	ship.position.y = original_ship_y + sin(Time.get_ticks_msec() / 1000.0 * speed) * amplitude
	catarg.position.y = original_catarg_y + sin(Time.get_ticks_msec() / 1000.0 * speed) * amplitude
