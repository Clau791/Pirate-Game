extends Area2D


func _on_body_entered(body: Node2D) -> void:
	$AnimatedSprite2D.play("default")
