extends Area2D

func _on_body_entered(body):
	if body.name == "player":
		body.collect_key()
		queue_free()
