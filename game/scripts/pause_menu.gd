extends Control


func _ready():
	visible = false


func _input(event):
	if event.is_action_pressed("pause"):
		visible = not visible


func _on_pause_scene_visibility_changed():
	get_tree().paused = visible


func _on_resume_pressed():
	visible = false
