class_name Player
extends CharacterBody2D

@export var speed := 150
@export var jump_force := 200

@export var acceleration = 0.25
@export var friction := 0.05

@onready var game: Game = get_tree().current_scene
@onready var arm: Node2D = $Shoulder
@onready var arm2: Node2D = $Shoulder
@onready var weapon: Weapon = $Shoulder/Arm/Pistol
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var ground_cast_left: RayCast2D = $GroundCast/GroundCastLeft
@onready var ground_cast_right: RayCast2D = $GroundCast/GroundCastRight
@onready var ground_cast_center: RayCast2D = $GroundCast/GroundCastCenter

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var velocity := Vector2.ZERO
var pistol_path := "res://scenes/weapons/pistol/pistol.tscn"

var can_fire := true
var jumped := false
var coyote_time := false


func _input(event):
	if event.is_action_pressed("fire_1") and can_fire:
		weapon.set_fire(true)
	elif event.is_action_released("fire_1"):
		weapon.set_fire(false)


func _physics_process(delta: float):
	arm.look_at(get_global_mouse_position())
	if arm.rotation > -PI/2:
		arm.scale.y = 1
	else:
		arm.scale.y = -1
	
	var grounded := is_grounded()
	if grounded:
		coyote_time = true
	elif coyote_timer.is_stopped():
		coyote_timer.start()
	
	var gravity_dir := global_position.direction_to(game.get_gravity_point()).normalized()
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
	
	if coyote_time and Input.is_action_just_pressed("jump"):
		velocity = Vector2(velocity.x, -jump_force)
		jumped = true
	elif jumped and Input.is_action_just_released("jump"):
		jumped = false
		if velocity.y < 0:
			velocity.y = 0
	
	motion_velocity = velocity.rotated(rotation)
	move_and_slide()
	
	if is_grounded():
		if move_dir != 0:
			anim_sprite.play("run")
		elif motion_velocity.length() > 40:
			anim_sprite.play("slide")
		else:
			anim_sprite.play("idle")
	else:
		anim_sprite.play("jump")
	if abs(velocity.x) > 2:
		anim_sprite.flip_h = velocity.x < 0
	

func is_grounded() -> bool:
	return ground_cast_left.is_colliding() or ground_cast_right.is_colliding() or ground_cast_center.is_colliding()


func change_weapon(weapon_path):
	var new_weapon = load(weapon_path).instantiate()
	arm2.add_child(new_weapon)
	weapon.queue_free()
	weapon = new_weapon
	weapon.connect("out_of_ammo", _on_out_of_ammo)
	weapon.set_fire(Input.is_action_pressed("fire_1"))


func _on_out_of_ammo():
	change_weapon(pistol_path)

func _on_coyote_timer_timeout():
	coyote_time = false


func _on_fire_collison_check_body_entered(body):
	can_fire = false
	weapon.set_fire(false)


func _on_fire_collison_check_body_exited(body):
	can_fire = true
	if Input.is_action_pressed("fire_1"):
		weapon.set_fire(true)
