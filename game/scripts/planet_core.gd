extends Area2D

@onready var game: Game = get_tree().current_scene


func _ready():
	connect("body_entered", _on_body_eneted)


func _on_body_eneted(body: Node2D):
	game.get_node("Planet").get_node("Destructible").expode(global_transform, $ExplodeShape.polygon)
	game.game_over()
