extends Control


func _on_planet_core_game_over():
	visible = true


func _on_continue_pressed():
	Engine.time_scale = 1
	get_tree().paused = false
	get_tree().change_scene("res://scenes/game.tscn")
