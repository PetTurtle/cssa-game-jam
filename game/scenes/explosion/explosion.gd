extends Node2D

@export var free_time := 10


func _ready():
	var timer := Timer.new()
	timer.process_mode = Timer.TIMER_PROCESS_PHYSICS
	timer.wait_time = free_time
	add_child(timer)
	timer.connect("timeout", _on_timeout_timer)
	timer.start()
	
	for child in get_children():
		if child is CPUParticles2D:
			child.emitting = true


func _on_timeout_timer():
	queue_free()
