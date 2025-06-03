extends Area2D

@export var item: InvItem 
var player = null 

func _on_body_entered(body: Node2D):
	print("Body entered:", body.name)  # Check if the body is entered
	if body.is_in_group("player"):
		body.tresure_pick_up("Red Diamond")
		player = body
		if item:
			print("Collecting item:", item.name)  # Verify that item is correctly assigned
			body.collect(item)  # Add item to the inventory
		else:
			print("Item is not assigned!")  # Debugging message if item is null
		await get_tree().create_timer(0.15).timeout
		queue_free()  # Remove the potion after 0.15 seconds
