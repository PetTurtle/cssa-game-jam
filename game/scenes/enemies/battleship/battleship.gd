extends RigidDynamicBody2D

@onready var game: Game = get_tree().current_scene
@onready var fire_raycast: RayCast2D = $Turret/RayCast2D
@onready var weapon: Weapon = $Turret/Weapon
@onready var turret: Node2D = $Turret


func _process(delta):
	weapon.set_fire(fire_raycast.is_colliding())


func _physics_process(delta):
	turret.look_at(get_tree().current_scene.gravity.global_position)
	look_at(global_position + linear_velocity)


func _on_damageable_damaged():
	pass # Replace with function body.


func _on_damageable_destroyed():
	pass # Replace with function body.
