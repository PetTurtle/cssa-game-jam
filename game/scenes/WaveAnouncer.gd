extends Control

@onready var label: Label = $Label


func _on_wave_spawner_wave_spawned(name):
	label.text = name
	var tween := create_tween()
	tween.tween_property(label, "percent_visible", 1.0, 2)
	tween.tween_interval(5)
	tween.tween_property(label, "percent_visible", 0.0, 2)
