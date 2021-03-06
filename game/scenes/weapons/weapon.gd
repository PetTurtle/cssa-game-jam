class_name Weapon
extends Node2D

signal out_of_ammo()

@export var rof := 5.0
@export var burst: int = 1
@export var recoil: float = PI/128.0
@export var spread: float = PI/8.0
@export var recoil_anim := false
@export var ammo: int = 100
@export var use_ammo := false
@export_global_file(PackedScene) var bullet_path: String
@export_node_path(Node2D) var fire_points_path: NodePath
@export_node_path(AudioStreamPlayer2D) var fire_sound_path: NodePath

var fire := false
var fire_points := []
var fire_point_index := 0
var fire_timer: Timer

var curr_spread: float = 0.0
var recoil_timer: Timer

@onready var bullet_scene: PackedScene = load(bullet_path)
@onready var fire_sound: AudioStreamPlayer2D = get_node(fire_sound_path)


func _ready():
	fire_timer = Timer.new()
	fire_timer.process_mode = Timer.TIMER_PROCESS_PHYSICS
	fire_timer.wait_time = 1.0/rof
	fire_timer.one_shot = true
	add_child(fire_timer)
	fire_timer.connect("timeout", _on_fire_timer)
	
	recoil_timer = Timer.new()
	recoil_timer.process_mode = Timer.TIMER_PROCESS_PHYSICS
	recoil_timer.wait_time = 0.5
	recoil_timer.one_shot = true
	add_child(recoil_timer)
	recoil_timer.connect("timeout", _on_recoil_timer)
	
	var points: Node2D = get_node(fire_points_path)
	for point in points.get_children():
		fire_points.append(point)


func set_fire(state: bool):
	fire = state
	if fire:
		fire_timer.one_shot = false
		if fire_timer.is_stopped():
			fire_timer.start()
			_fire()
	else:
		fire_timer.one_shot = true


func _on_fire_timer():
	if fire:
		_fire()
		fire_timer.start()


func _on_recoil_timer():
	if not fire:
		curr_spread = 0


func _fire():
	for _i in range(burst):
		var bullet = bullet_scene.instantiate()
		bullet.position = fire_points[fire_point_index].global_position
		fire_point_index = (fire_point_index+1) % fire_points.size()
		bullet.rotation = global_rotation + randf_range(-curr_spread, curr_spread)
		get_tree().current_scene.call_deferred("add_child", bullet)
		curr_spread = min(spread, curr_spread + recoil)
	if recoil_anim:
		var tween := create_tween()
		tween.parallel().tween_property($Sprite, "rotation", randf_range(-spread, spread), 0.05)
		tween.parallel().tween_property($Sprite, "position", Vector2(-4, 0), fire_timer.wait_time/4)
		tween.tween_property($Sprite, "rotation", 0.0, fire_timer.wait_time/2)
		tween.tween_property($Sprite, "position", Vector2(0, 0), fire_timer.wait_time/2)
	ammo -= 1
	if use_ammo and ammo == 0:
		emit_signal("out_of_ammo")
	recoil_timer.start()
	fire_sound.play()
