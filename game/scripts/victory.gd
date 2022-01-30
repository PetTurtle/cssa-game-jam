extends Control


func _on_wave_spawner_victory():
	visible = true
	get_tree().paused = true


func _on_continue_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://scenes/Menu.tscn")
