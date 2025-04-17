extends AnimatedSprite2D


# implementam miscarea norilor variabila
# prob / viteza
var speeds = [[0.05, 2],[0.1, 4],[0.1, 6],[0.2, 7],[0.3, 8],[0.1, 9], [0.1, 10],[0.05, 11] ]
var speed_intervals = [
	[0.0, 0.05],
	[0.05, 0.15],
	[0.15, 0.25],
	[0.25, 0.45],
	[0.45, 0.75],
	[0.75, 0.85],
	[0.85, 0.95],
	[0.95, 1.0]
]
var animation_stopped = true
var speed = 0

func set_animation_stopped():
	animation_stopped = true
	# timer o seteaza
	
func random_animation_play():
	var r = randf()# random float in [0, 1]
	for i in range(speed_intervals.size()):
		var interval = speed_intervals[i]
		if r >= interval[0] and r < interval[1]:
			return speeds[i][1]  # returnează viteza asociată
	
func _ready() -> void:

		
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if animation_stopped:
		speed = random_animation_play()
		animation_stopped = false
		$Dynamic_Speed_Timer.start()
		
	position.x += speed * delta  # adaugă *delta pentru mișcare frame-rate independentă	
		
	pass
