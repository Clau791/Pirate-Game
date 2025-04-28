extends Control

var is_paused := false

@onready var main_menu = $MainMenu   # VBoxContainer cu butoane principale
@onready var help_menu = $HelpMenu    # VBoxContainer cu informații despre controale
@onready var color_rect = $ColorRect  # Fundalul semi-transparent (opțional)

func _ready():
	hide()  # Ascundem tot meniul la început
	help_menu.hide()  # Ascundem HelpMenu la început
	set_process_mode(Node.PROCESS_MODE_ALWAYS)  # Meniul procesează mereu

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		toggle_pause_menu()

func toggle_pause_menu():
	is_paused = not is_paused
	get_tree().paused = is_paused
	visible = is_paused

	if is_paused:
		main_menu.show()
		help_menu.hide()
		color_rect.modulate.a = 0.5  # Fundal semi-transparent
	else:
		color_rect.modulate.a = 0.0  # Fundal complet transparent

func _on_help_button_pressed():
	main_menu.hide()
	help_menu.show()

# Când apeși pe butonul "Înapoi" din HelpMenu
func _on_back_button_pressed():
	help_menu.hide()
	main_menu.show()
