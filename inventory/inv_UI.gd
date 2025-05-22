extends Control  


@export var inv: Inv
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

var is_visible := false

# Functia _ready() pentru a ascunde inventarul initial
func _ready():
	inv.update.connect(update_slots)
	update_slots()
	hide()  # Ascunde inventarul la început
	process_mode = Node.PROCESS_MODE_ALWAYS  
	
	# Center the inventory in the viewport
	await get_tree().process_frame  # Wait one frame so size info is valid
	position = (get_viewport().get_visible_rect().size - size) / 2


func update_slots():
	for i in range(min(inv.slots.size(), slots.size())):
		slots[i].update(inv.slots[i])
		
# Functia pentru a prinde input-ul utilizatorului
func _unhandled_input(event):
	if event.is_action_pressed("toggle_inventory"):
		toggle_inventory()

# Functia de toggle a inventarului
func toggle_inventory():
	is_visible = !is_visible
	visible = is_visible
	get_tree().paused = is_visible
