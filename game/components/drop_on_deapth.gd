class_name DropOnDeath
extends Node

@export_range(1, 100) var drop_chance: int = 25

var drop_scene = preload("res://scenes/entities/drop/drop.tscn")

func _exit_tree():
	if randi_range(0, 100) <= drop_chance:
		var drop = drop_scene.instantiate()
		drop.global_position = get_parent().global_position
		get_tree().current_scene.add_child(drop)
