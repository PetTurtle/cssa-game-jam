class_name SpawnOnDeath
extends Node

@onready var game: Game = get_tree().current_scene
@export_global_file(PackedScene) var explosion_path: String = "res://scenes/explosion/explosion_med.tscn"

func _exit_tree():
	var boom = load(explosion_path).instantiate()
	game.add_child(boom)
	boom.global_position = get_parent().global_position
	boom.global_rotation = get_parent().global_rotation
