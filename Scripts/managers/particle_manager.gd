extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func spawn_sparks():
	$"../../VFXLayer/SparkParticle".emitting = true

func spawn_blood_p2():
	$"../../VFXLayer/BloodSlash1".emitting = true

func spawn_blood_p1():
	$"../../VFXLayer/BloodSlash2".emitting = true
