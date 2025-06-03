extends Resource

class_name Inv

signal update
@export var slots: Array[InvSlot]

func insert(item: InvItem):
	var itemslots = slots.filter(func(slot): return slot.item == item)
	if !itemslots.is_empty():
		itemslots[0].amount += 1
	else:
		var emptyslots = slots.filter(func(slot): return slot.item == null)
		if !emptyslots.is_empty():
			emptyslots[0].item = item
			emptyslots[0].amount = 1
	update.emit()

func remove_item(item_name: String, amount: int = 1) -> void:
	for slot in slots:
		if slot.item and slot.item.name == item_name:
			slot.amount -= amount
			if slot.amount <= 0:
				slots.erase(slot)
			update.emit() 
			return
