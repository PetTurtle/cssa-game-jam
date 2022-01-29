class_name BoidField
extends Node

@onready var game: Game = get_tree().current_scene


func _ready():
	game.add_boid_field(get_parent())
	connect("tree_exiting", _on_tree_exiting)

func _on_tree_exiting():
	game.remove_boid_feild(get_parent())
