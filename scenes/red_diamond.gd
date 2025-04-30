extends Area2D


func _on_body_entered(body: Node2D) -> void:
	body.pick_up_potion("Red Diamond")
	await get_tree().create_timer(0.15).timeout
	queue_free()
