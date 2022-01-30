extends Control

var game_scene = preload("res://scenes/game.tscn")


func _on_play_pressed():
	$Transition.close()


func _on_exit_pressed():
	get_tree().quit()


func _on_transition_closed():
	get_tree().change_scene_to(game_scene)
