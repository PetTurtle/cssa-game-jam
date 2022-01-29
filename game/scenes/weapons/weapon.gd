class_name Weapon
extends Node2D

@export var rof := 5.0
@export var recoil := 10
@export var spread := 30
@export_global_file(PackedScene) var bullet_path: String
@export_node_path(Node2D) var fire_points_path: NodePath

var fire := false
var fire_points := []
var fire_point_index := 0
var fire_timer: Timer

@onready var bullet_scene: PackedScene = load(bullet_path)


func _ready():
	fire_timer = Timer.new()
	fire_timer.process_mode = Timer.TIMER_PROCESS_PHYSICS
	fire_timer.wait_time = 1.0/rof
	fire_timer.one_shot = true
	add_child(fire_timer)
	fire_timer.connect("timeout", _on_fire_timer)
	
	var points: Node2D = get_node(fire_points_path)
	for point in points.get_children():
		fire_points.append(point)


func set_fire(state: bool):
	fire = state
	if fire:
		fire_timer.one_shot = false
		if fire_timer.is_stopped():
			fire_timer.start()
			var bullet = bullet_scene.instantiate()
			bullet.position = fire_points[fire_point_index].global_position
			bullet.rotation = global_rotation
			get_tree().current_scene.add_child(bullet)
	else:
		fire_timer.one_shot = true


func _on_fire_timer():
	if fire:
		var bullet = bullet_scene.instantiate()
		bullet.position = fire_points[fire_point_index].global_position
		bullet.rotation = global_rotation
		get_tree().current_scene.add_child(bullet)
		fire_timer.start()



