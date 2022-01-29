class_name Destructible
extends Sprite2D

@export_range(0.01, 10) var detail := 1.0
@export var block_size := Vector2(25, 25)
@export var min_block_area := 100.0

@onready var body: PhysicsBody2D = get_parent()

var width: int
var max_size: int
var quadtree: QuadTree


func _ready():
	visible = false
	var bitmap := BitMap.new()
	var image := texture.get_image()
	bitmap.create_from_image_alpha(image, 0.1)
	var image_size := image.get_size()
	width = int(image_size.x / block_size.x)
	max_size = (image_size.x / block_size.x) * (image_size.y / block_size.y)
	quadtree = QuadTree.new(Rect2i(Vector2i.ZERO, image_size/block_size), 4, 8)
	for y in range(0, image_size.y-block_size.y+1, block_size.y):
		for x in range(0, image_size.x-block_size.x+1, block_size.x):
			var transfrom := Transform2D(0, Vector2(x,-y))
			var rect := Rect2(Vector2(x,y), Vector2(x + block_size.x,y + block_size.y))
			for polygon in bitmap.opaque_to_polygons(rect, detail):
				_create_block(transfrom * polygon, Vector2i(x/block_size.x, y/block_size.y))


func _input(event):
	if event.is_action_pressed("mouse_1"):
		expode(get_local_mouse_position())
	elif event.is_action_pressed("mouse_2"):
		var aa = load("res://rigid_dynamic_body_2d.tscn").instantiate()
		get_tree().current_scene.add_child(aa)
		aa.position = get_local_mouse_position()


func expode(pos: Vector2):
	pos = to_local(pos)
	var transfrom := Transform2D(0, pos)
	var grid = (pos/block_size).floor()
	var blocks = quadtree.query(grid.x, grid.y, 1.5)
	for block in blocks:
		var res = Geometry2D.clip_polygons(block[1].polygon, transfrom * $Shape.polygon)
		if res.size() > 0:
			print(_get_area(res[0]))
			if _get_area(res[0]) < min_block_area:
				block[1].queue_free()
				block[0].queue_free()
				quadtree.remove(block[2], block)
			else:
				block[1].polygon = res[0]
				block[0].set_deferred("polygon", res[0])
			for i in range(1, res.size()):
				if _get_area(res[i]) >= min_block_area:
					_create_block(res[i], Vector2.ZERO)


func _create_block(array: PackedVector2Array, pos: Vector2i):
	var collision = CollisionPolygon2D.new()
	collision.polygon = array
	body.call_deferred("add_child", collision)
	var polygon = Polygon2D.new()
	polygon.polygon = array
	polygon.texture = texture
	body.call_deferred("add_child", polygon)
	quadtree.insert(pos, [collision, polygon])


func _get_center(array: PackedVector2Array):
	var center := Vector2.ZERO
	for vector in array:
		center += vector
	center/array.size()
	var transfrom := Transform2D(0, center)


func _get_area(array: PackedVector2Array) -> float:
	var a := 0.0
	var b := 0.0
	for i in range(0, array.size()):
		a += array[i].x * array[(i+1)%(array.size())].y
		b += array[i].y * array[(i+1)%(array.size())].x
	print((a - b) * 0.5)
	return (a - b) * 0.5
