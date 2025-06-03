extends Area2D

func _on_body_entered(body):
	print("Entered by:", body.name, "Type:", body.get_class())
	print("Player has entered unlock zone!")  # adăugat pentru test

	if body.name == "player":
		print("Has key:", body.has_key)  # vezi dacă e TRUE

		if body.has_key:
			print("Destroying totem!")
			body.inv.remove_item("key", 1)
			get_parent().queue_free()
		else:
			print("Player needs a key!")
