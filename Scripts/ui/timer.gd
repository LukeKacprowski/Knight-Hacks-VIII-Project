extends TextureProgressBar

var round_time: float = 0.0
var current_time: float = 0.0

func _ready() -> void:
	max_value = 100
	value = 100

func _process(_delta: float) -> void:
	if round_time > 0:
		# Calculate percentage remaining
		var percentage = (current_time / round_time) * 100.0
		value = clamp(percentage, 0, 100)

func start_timer(time: float):
	round_time = time
	current_time = time
	value = 100

func update_time(time: float):
	current_time = time
