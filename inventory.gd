extends Control  

var is_visible := false

func _ready():
	hide()
	process_mode = Node.PROCESS_MODE_ALWAYS  

func _unhandled_input(event):
	if event.is_action_pressed("toggle_inventory"):
		toggle_inventory()

func toggle_inventory():
	is_visible = !is_visible
	visible = is_visible
	get_tree().paused = is_visible
