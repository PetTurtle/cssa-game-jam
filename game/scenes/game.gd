class_name Game
extends Node2D

@onready var player: Player = $Player
@onready var gravity: Position2D = $GravityPoint


func get_gravity_point() -> Vector2:
	return gravity.global_position


func game_over():
	pass
