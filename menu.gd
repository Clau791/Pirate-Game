extends Control

var is_paused := false

func _ready():
	hide()  # Ascundem meniul la început
	process_mode = Node.PROCESS_MODE_ALWAYS  # Meniul să funcționeze și când jocul e în pauză

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):  # "ui_cancel" = ESC
		toggle_pause_menu()

func toggle_pause_menu():
	is_paused = not is_paused
	get_tree().paused = is_paused
	visible = is_paused
