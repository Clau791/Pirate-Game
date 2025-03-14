extends CanvasLayer

var transition_time = 1.0  # Timpul de tranziție (în secunde)

# Funcția care face fade-out și schimbă scena
func start_transition_to_scene(scene_path: String):
	# Fade-out (ColorRect devine vizibil)
	var fade_out_tween = create_tween()
	fade_out_tween.set_trans(Tween.TRANS_LINEAR)
	fade_out_tween.set_ease(Tween.EASE_IN)
	fade_out_tween.tween_property($ColorRect, "modulate:a", 1, transition_time)
	
	# Așteaptă ca fade-out să se termine
	await fade_out_tween.finished
	
	# Schimbă scena
	get_tree().change_scene_to_file(scene_path)
	
	# Așteaptă să se încarce scena nouă
	await get_tree().idle_frame
	
	# Fade-in (ColorRect devine transparent din nou)
	var fade_in_tween = create_tween()
	fade_in_tween.set_trans(Tween.TRANS_LINEAR)
	fade_in_tween.set_ease(Tween.EASE_IN)
	fade_in_tween.tween_property($ColorRect, "modulate:a", 0, transition_time)
	
	# Așteaptă ca fade-in să se termine
	await fade_in_tween.finished
