class_name QuadTree
extends Resource

var _rect: Rect2i
var _capacity: int
var _max_depth: int
var _depth: int
var _data := {}
var _data_count := 0

var _top_left: QuadTree
var _top_right: QuadTree
var _bottom_left: QuadTree
var _bottom_right: QuadTree
var _subdivided := false


func _init(rect: Rect2i, capacity: int, max_depth: int, depth: int = 0):
	_rect = rect
	_capacity = capacity
	_max_depth = max_depth
	_depth = depth


func insert(point: Vector2i, data):
	if _rect.has_point(point):
		data.append(point)
		_insert(point, data)


func remove(point: Vector2i, data):
	if _rect.has_point(point):
		_remove(point, data)


func query(x: float, y: float, radius: float) -> Array:
	var found := []
	_query(Rect2(x - radius, y - radius, radius * 2, radius * 2), found)
	return found


func _insert(point: Vector2i, data):
	if _data_count < _capacity or _depth >= _max_depth:
		_data[data] = point
		_data_count += 1
	elif _subdivided:
		_get_subnode(point)._insert(point, data)
	else:
		_subdivide()
		_get_subnode(point)._insert(point, data)


func _remove(point: Vector2i, data):
	if _data.has(data):
		_data.erase(data)
		_data_count -= 1
	elif _subdivided:
		_get_subnode(point)._remove(point, data)
		if _are_children_empty():
			_top_left = null
			_top_right = null
			_bottom_left = null
			_bottom_right = null
			_subdivided = false


func _query(rect: Rect2, found: Array):
	for key in _data:
		if rect.has_point(_data[key]):
			found.append(key)

	if _subdivided and rect.intersects(_rect):
		_top_left._query(rect, found)
		_top_right._query(rect, found)
		_bottom_left._query(rect, found)
		_bottom_right._query(rect, found)


func _are_children_empty() -> bool:
	return _top_left._is_empty() and _top_right._is_empty() and _bottom_left._is_empty() and _bottom_right._is_empty()


func _is_empty() -> bool:
	return _subdivided == false and _data_count == 0


func _subdivide():
	var x = _rect.position.x
	var y = _rect.position.y
	var width = _rect.size.x * 0.5
	var height = _rect.size.y * 0.5
	_top_left = QuadTree.new(Rect2i(x, y, width, height), _capacity, _max_depth, _depth + 1)
	_top_right = QuadTree.new(Rect2i(x + width, y, width, height), _capacity, _max_depth,  _depth + 1)
	_bottom_left = QuadTree.new(Rect2i(x, y + height, width, height), _capacity, _max_depth,  _depth + 1)
	_bottom_right = QuadTree.new(Rect2i(x + width, y + height, width, height), _capacity, _max_depth,  _depth + 1)
	_subdivided = true


func _get_subnode(point: Vector2i) -> QuadTree:
	var cX = _rect.position.x + _rect.size.x * 0.5
	var cY = _rect.position.y + _rect.size.y * 0.5
	if point.x < cX:
		if point.y < cY:
			return _top_left
		return _bottom_left
	else:
		if point.y < cY:
			return _top_right
		return _bottom_right
