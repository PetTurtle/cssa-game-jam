class_name Game
extends Node2D



@onready var planet = $Planet
@onready var player = $Player
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


func _on_exit_pressed():
	Engine.time_scale = 1
	$UI/Transition.close()



func _on_transition_closed():
	get_tree().paused = false
	get_tree().change_scene("res://scenes/Menu.tscn")
