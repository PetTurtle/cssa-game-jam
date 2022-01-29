extends RigidDynamicBody2D

@onready var game: Game = get_tree().current_scene


func _physics_process(delta):
	look_at(global_position + linear_velocity)


func _on_damageable_damaged():
	pass # Replace with function body.


func _on_damageable_destroyed():
	queue_free()
