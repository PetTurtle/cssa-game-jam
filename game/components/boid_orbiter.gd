class_name BoidOrbiter
extends Node

@export var speed := 20
@export var orbit_speed := 5
@export var separation := 35
@export var orbit_distance_min := 210
@export var orbit_distance_max := 230

@onready var game: Game = get_tree().current_scene
@onready var body: RigidDynamicBody2D = get_parent()

var rebound_angle: float = 0
var is_attacking := true


func _ready():
	rebound_angle = randf_range(-PI/2,PI/2)


func _physics_process(delta):
	for node in game.get_boid_fields():
		if node != body:
			var distance = body.global_position.distance_to(node.global_position)
			if distance < separation:
				body.apply_central_impulse(node.global_position.direction_to(body.global_position).normalized() * separation / distance * speed * 4 * delta)
	
	body.apply_central_impulse(body.global_position.direction_to(game.gravity.global_position).rotated(PI/2) * orbit_speed * delta)
	
	if game.gravity != null:
		if is_attacking:
			if body.global_position.distance_to(game.gravity.global_position) > orbit_distance_min:
				body.apply_central_impulse(body.global_position.direction_to(game.gravity.global_position) * speed * delta)
			else:
				body.apply_central_impulse(-body.global_position.direction_to(game.gravity.global_position).rotated(rebound_angle) * speed * delta)
				is_attacking = false
		else:
			if body.global_position.distance_to(game.gravity.global_position) > orbit_distance_max:
				body.apply_central_impulse(body.global_position.direction_to(game.gravity.global_position) * speed * delta)
				is_attacking = true
			else:
				body.apply_central_impulse(-body.global_position.direction_to(game.gravity.global_position).rotated(rebound_angle) * speed * delta)
			
