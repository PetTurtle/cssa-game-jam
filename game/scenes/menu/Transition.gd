extends ColorRect

signal opened()
signal closed()

func close():
	$AnimationPlayer.play("close")


func open():
	$AnimationPlayer.play("open")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "open":
		emit_signal("opened")
	else:
		emit_signal("closed")

