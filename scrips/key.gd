extends Area2D

@export var item: InvItem 

func _on_body_entered(body):
	if body.name == "player":
		body.collect_key()
		body.collect(item)
		queue_free()
