extends CharacterBody2D

@export var speed := 150
@export var jump_force := 200

@export var acceleration = 0.25
@export var friction := 0.5

@onready var arm: Node2D = $Shoulder
@onready var ground_cast_left: RayCast2D = $GroundCast/GroundCastLeft
@onready var ground_cast_right: RayCast2D = $GroundCast/GroundCastRight
@onready var ground_cast_center: RayCast2D = $GroundCast/GroundCastCenter

@onready var gravity_point: Node2D = get_tree().current_scene.gravity

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var velocity := Vector2.ZERO
var jumped := false


func _physics_process(delta: float):
	arm.look_at(get_global_mouse_position())
	
	var grounded := is_grounded()
	var gravity_dir := global_position.direction_to(get_tree().current_scene.gravity.global_position).normalized()
	motion_velocity += gravity_dir * gravity * delta
	rotation = gravity_dir.angle() - PI/2
	up_direction = gravity_dir * -1
	
	var velocity = motion_velocity.rotated(-rotation)
	var move_dir := Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	if move_dir != 0:
		velocity.x = lerp(velocity.x, move_dir * speed, acceleration)
		if grounded:
			velocity.y = lerp(velocity.y, -20, acceleration)
	elif grounded:
		velocity.x = lerp(velocity.x, 0 , friction)
	
	if grounded and Input.is_action_just_pressed("jump"):
		velocity = Vector2(velocity.x, -jump_force)
		jumped = true
	elif jumped and Input.is_action_just_released("jump"):
		jumped = false
		if velocity.y < 0:
			velocity.y = 0
	
	motion_velocity = velocity.rotated(rotation)
	move_and_slide()
	

func is_grounded() -> bool:
	return ground_cast_left.is_colliding() or ground_cast_right.is_colliding() or ground_cast_center.is_colliding()
