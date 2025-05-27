extends Node2D

@onready var label = $Chenar/Dialog
@onready var chenar = $Chenar
@onready var area = $Area2D
@onready var exclamation = $idle/exclamation

var dialog_lines = [
	"Ahoy there, Treasure Hunter!",
	"Welcome aboard the Lost Island o' Whisperin' Skulls!",
	"The name’s Billy – or Cap'n Bill, if ye fancy.",
	"I been marooned on this cursed rock for over two decades",
	"and blast it, I never had much lust for the shiny treasure around these parts.",
	"Can’t say the same fer the poor souls who lost their lives chasin’ it.",
	"So watch yer step, young traveler — this island’s full o’ dark surprises..."
]
	

var current_line = 0
var player_near = false
var dialog_active = false

func _ready():
	label.visible = false
	chenar.visible = false
	label.text = ""

func _process(_delta):
	if player_near and dialog_active and Input.is_action_just_pressed("accept_dialog"):
		show_next_line()

func _on_Area2D_body_entered(body):
	if body.name == "player":  # sau body.is_in_group("player")
		player_near = true
		chenar.visible = true
		exclamation.visible = false
		dialog_active = true
		current_line = 0
		label.visible = true
		label.text = dialog_lines[current_line]

func _on_Area2D_body_exited(body):
	if body.name == "player":
		player_near = false
		chenar.visible = false
		dialog_active = false
		label.visible = false
		exclamation.visible = true
		label.text = ""

func show_next_line():
	current_line += 1
	if current_line < dialog_lines.size():
		label.text = dialog_lines[current_line]
	else:
		label.visible = false
		dialog_active = false
