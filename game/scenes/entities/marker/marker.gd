extends Node2D

@onready var point: Node2D = $Point
@onready var icon: Node2D = $Point/Icon

func _ready():
	var tween := create_tween()
	point.scale = Vector2.ZERO
	tween.tween_property(point, "scale", Vector2.ONE, 1)


func _process(delta):
	var size = get_viewport_rect().size / get_canvas_transform().get_scale()
	var cam = get_viewport().get_camera_2d()
	var local_point = cam.to_local(global_position)
	visible = not Rect2(-size/2.0, size).has_point(local_point)
	if visible:
		var bounds := Rect2(-size/2.0, size/2.0)
		local_point.x = clamp(local_point.x, bounds.position.x, bounds.size.x)
		local_point.y = clamp(local_point.y, bounds.position.y, bounds.size.y)
		point.global_position = cam.to_global(local_point)
		var angle = (global_position - point.global_position).angle()
		point.global_rotation = angle
		icon.global_rotation = cam.global_rotation


