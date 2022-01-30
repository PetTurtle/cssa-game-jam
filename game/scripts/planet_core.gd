extends Area2D

signal game_over()

@onready var game: Game = get_tree().current_scene


func _ready():
	connect("body_entered", _on_body_entered)
	connect("area_entered", _on_area_entered)


func _on_body_entered(body: Node2D):
	$GameOverTimer.start()
	game.get_node("Planet").get_node("Destructible").expode(global_transform, $ExplodeShape.polygon)
	game.player.gravity = 0
	game.player.motion_velocity = Vector2.ZERO
	game.player.visible = false
	Engine.time_scale = 0.5
	$Explode.emitting = true
	$Explode2.emitting = true
	$Explode3.emitting = true


func _on_area_entered(area: Area2D):
	$GameOverTimer.start()
	game.get_node("Planet").get_node("Destructible").expode(global_transform, $ExplodeShape.polygon)
	game.player.gravity = 0
	game.player.motion_velocity = Vector2.ZERO
	game.player.visible = false
	Engine.time_scale = 0.5
	$Explode.emitting = true
	$Explode2.emitting = true
	$Explode3.emitting = true


func _on_game_over_timer_timeout():
	emit_signal("game_over")
