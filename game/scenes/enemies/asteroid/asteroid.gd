extends RigidDynamicBody2D

@export var sub_count := 2
@export_global_file(RigidDynamicBody2D) var sub_divs_path: String

@onready var game: Game = get_tree().current_scene
@onready var subdiv: PackedScene = null

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready():
	connect("body_entered", _on_body_entered)
	randomize()
	angular_velocity = randf_range(-0.5, 0.5)
	if sub_divs_path != "":
		subdiv = load(sub_divs_path)


func _physics_process(delta):
	var gravity_dir := global_position.direction_to(game.get_gravity_point()).normalized()
	apply_central_force(gravity_dir * gravity * mass * delta)


func _on_damageable_damaged():
	pass # Replace with function body.


func _on_damageable_destroyed():
	spawn_subdiv()
	queue_free()


func _on_body_entered(body: Node):
	if body.has_node("Destructible"):
		scale = Vector2(1.5, 1.5)
		body.get_node("Destructible").expode(global_transform, $CollisionPolygon2D.polygon)
		queue_free()


func spawn_subdiv():
	if subdiv:
		for _i in range(sub_count):
			var asteroid = subdiv.instantiate()
			get_tree().current_scene.call_deferred("add_child", asteroid)
			asteroid.global_position = global_position
			asteroid.linear_velocity = Vector2.UP.rotated(randf_range(0, 2*PI))  * randf_range(35, 50)
