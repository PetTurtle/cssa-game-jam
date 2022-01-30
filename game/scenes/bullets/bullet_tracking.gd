class_name BulletTracking
extends Area2D

@export var speed: float = 500.0
@export var damage: int = 1
@export var track_speed: float = 500.0
@export var track_distance := 100
@export var max_speed := 100.0
@export var timeout_time: float = 10.0
@export_node_path(Polygon2D) var destruction_polygon_path: NodePath

var timeout_timer: Timer
var velocity: Vector2

@onready var game: Game = get_tree().current_scene
@onready var destruction_polygon: Polygon2D = get_node(destruction_polygon_path)


func _ready():
	connect("body_entered", _on_body_entered)
	timeout_timer = Timer.new()
	timeout_timer.process_mode = Timer.TIMER_PROCESS_PHYSICS
	timeout_timer.wait_time = timeout_time
	add_child(timeout_timer)
	timeout_timer.connect("timeout", _on_timeout_timer)
	timeout_timer.start()
	velocity = Vector2(speed, 0).rotated(rotation)


func _physics_process(delta: float):
	for node in game.get_boid_fields():
		var distance = global_position.distance_to(node.global_position)
		if distance < track_distance:
			velocity += global_position.direction_to(node.global_position).normalized() * track_distance / distance * speed * 4 * delta
	velocity = velocity.limit_length(max_speed)
	look_at(global_position + velocity)
	global_position += velocity * delta


func _on_body_entered(body: Node):
	if body.has_node("Destructible"):
		body.get_node("Destructible").expode(global_transform, destruction_polygon.polygon)
	elif body.has_node("Damageable"):
		body.get_node("Damageable").damage(damage)
	queue_free()


func _on_timeout_timer():
	queue_free()


func _on_track_timer_timeout():
	pass # Replace with function body.
