class_name Trail
extends Line2D

@export var length: int = 5


func _physics_process(_delta):
	add_point(get_parent().global_position)

	if points.size() > length:
		remove_point(0)
