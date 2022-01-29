extends RigidDynamicBody2D

@onready var game: Game = get_tree().current_scene

@onready var fire_raycast: RayCast2D = $FireRayCast
@onready var weapon: Weapon = $Weapon


func _process(delta):
	weapon.set_fire(fire_raycast.is_colliding())


func _physics_process(delta):
	look_at(game.gravity.global_position)


func _on_damageable_damaged():
	pass # Replace with function body.


func _on_damageable_destroyed():
	queue_free()
