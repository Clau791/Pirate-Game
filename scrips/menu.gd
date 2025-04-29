extends Control

var is_paused := false

@onready var main_menu = $MainMenu  
@onready var help_menu = $HelpMenu   
@onready var settings_menu = $SettingsMenu
@onready var level_menu = $LevelMenu

func _ready():
	hide()  
	help_menu.hide()
	settings_menu.hide()
	level_menu.hide()
	set_process_mode(Node.PROCESS_MODE_ALWAYS)  

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		toggle_pause_menu()

func toggle_pause_menu():
	is_paused = not is_paused
	get_tree().paused = is_paused
	visible = is_paused

	if is_paused:
		main_menu.show()
		settings_menu.hide()
		help_menu.hide()
		level_menu.hide()
		

func _on_help_button_pressed():
	main_menu.hide()
	settings_menu.hide()
	level_menu.hide()
	help_menu.show()

func _on_back_button_pressed():
	help_menu.hide()
	settings_menu.hide()
	level_menu.hide()
	main_menu.show()

func _on_settings_button_pressed():
	settings_menu.show()
	help_menu.hide()
	main_menu.hide()
	level_menu.hide()

func _on_level_button_pressed():
	level_menu.show()
	settings_menu.hide()
	help_menu.hide()
	main_menu.hide()

func _on_exit_button_pressed() -> void:
	get_tree().quit() 
