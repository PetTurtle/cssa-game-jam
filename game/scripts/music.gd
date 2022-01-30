extends AudioStreamPlayer2D


func _on_audio_stream_player_2d_finished():
	stream = load("res://resources/audio/meet-the-princess.wav")
	play()
