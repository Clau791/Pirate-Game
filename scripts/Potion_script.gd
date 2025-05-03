extends Area2D


func _on_body_entered(body: Node2D) -> void:
	body.pick_up_potion("Blue Potion")
	await get_tree().create_timer(1.0).timeout
	queue_free()
