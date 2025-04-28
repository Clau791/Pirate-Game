extends TextureProgressBar


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func update(current_H, max_H):
	value = current_H * 100 / max_H
	
