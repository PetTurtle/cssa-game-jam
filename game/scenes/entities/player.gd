extends CharacterBody2D

@export var speed := 150
@export var jump_force := 250

@export var acceleration = 0.25
@export var friction := 0.5


@onready var camera: Camera2D = $Camera2D
@onready var gravity_point: Node2D = get_tree().current_scene.gravity

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var velocity := Vector2.ZERO


func _physics_process(delta: float):
	var gravity_dir := global_position.direction_to(get_tree().current_scene.gravity.global_position).normalized()
	motion_velocity += gravity_dir * gravity * delta
	rotation = gravity_dir.angle() - PI/2
	up_direction = gravity_dir * -1
	
	var velocity = motion_velocity.rotated(-rotation)
	var move_dir := Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	if move_dir != 0:
		velocity.x = lerp(velocity.x, move_dir * speed, acceleration)
		velocity.y = lerp(velocity.y, -75, acceleration)
	else:
		velocity.x = lerp(velocity.x, 0 , friction)
	
	if Input.is_action_just_pressed("jump"):
		velocity = Vector2(velocity.x, -jump_force)
		
	motion_velocity = velocity.rotated(rotation)
	move_and_slide()
	

