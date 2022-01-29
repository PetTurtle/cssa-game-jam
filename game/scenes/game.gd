class_name Game
extends Node2D

@onready var player: Player = $Player
@onready var gravity: Position2D = $GravityPoint

var boid_fields := {}


func get_gravity_point() -> Vector2:
	return gravity.global_position


func add_boid_field(node: Node2D):
	boid_fields[node] = true


func remove_boid_feild(node: Node2D):
	boid_fields.erase(node)


func get_boid_fields() -> Array:
	return boid_fields.keys()


func game_over():
	pass

