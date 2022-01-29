class_name Game
extends Node2D

@onready var gravity: Position2D = $GravityPoint

var rof_timer: Timer

func _ready():
	rof_timer = Timer.new()
	add_child(rof_timer)
