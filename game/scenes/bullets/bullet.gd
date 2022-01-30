class_name Bullet
extends Area2D

@export var speed: float = 500.0
@export var damage: int = 1
@export var timeout_time: float = 10.0
@export_global_file(PackedScene) var explosion_path: String
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
	global_position += velocity * delta


func _on_body_entered(body: Node):
	if body.has_node("Destructible"):
		body.get_node("Destructible").expode(global_transform, destruction_polygon.polygon)
	elif body.has_node("Damageable"):
		body.get_node("Damageable").damage(damage)
	var boom = load(explosion_path).instantiate()
	game.add_child(boom)
	boom.global_position = global_position
	boom.global_rotation = global_rotation
	queue_free()


func _on_timeout_timer():
	queue_free()
