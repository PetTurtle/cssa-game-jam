class_name Bullet
extends RigidDynamicBody2D

@export var start_velocity: float = 500.0
@export var damage: int = 1
@export var timeout_time: float = 10.0
@export_node_path(Polygon2D) var destruction_polygon_path: NodePath

var timeout_timer: Timer
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

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
	apply_central_impulse(Vector2(start_velocity, 0).rotated(rotation))


func _physics_process(delta):
	var gravity_dir := global_position.direction_to(game.get_gravity_point()).normalized()
	apply_central_force(gravity_dir * gravity * delta)
	look_at(global_position + linear_velocity)


func _on_body_entered(body: Node):
	if body.has_node("Destructible"):
		body.get_node("Destructible").expode(global_transform, destruction_polygon.polygon)
	queue_free()


func _on_timeout_timer():
	queue_free()
