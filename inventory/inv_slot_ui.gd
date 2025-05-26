extends Panel

@onready var item_visual: Sprite2D = $CenterContainer/Panel/item_display
@onready var slot_visual: Sprite2D = $Sprite2D
@onready var amount_text: Label = $CenterContainer/Panel/Label

func update(slot: InvSlot):
	if !slot.item:
		item_visual.visible = false
		amount_text.visible = false
	else: 
		item_visual.visible = true
		item_visual.texture = slot.item.texture
		if slot.amount > 1:
			amount_text.visible = true
		amount_text.text = str(slot.amount)
		var slot_size = slot_visual.texture.get_size() * slot_visual.scale

		# Item texture size
		var item_texture_size = slot.item.texture.get_size()

		# Calculate scale factor to fit item in slot
		var scale_factor = min(
			slot_size.x / item_texture_size.x,
			slot_size.y / item_texture_size.y)
			
		# (70% of slot size)
		var visual_padding = 0.7  # Lower = smaller item inside slot
		scale_factor *= visual_padding
		
		# Apply scale to item
		item_visual.scale = Vector2(scale_factor, scale_factor)
