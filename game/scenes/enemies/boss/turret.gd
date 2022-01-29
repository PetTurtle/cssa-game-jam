extends Node2D


@onready var game: Game = get_tree().current_scene
@onready var fire_raycast: RayCast2D = $RayCast2D
@onready var weapon: Weapon = $Weapon


func _process(delta):
	weapon.set_fire(fire_raycast.is_colliding())


func _physics_process(delta):
	look_at(get_tree().current_scene.gravity.global_position)
