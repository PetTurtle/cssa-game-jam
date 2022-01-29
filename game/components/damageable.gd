class_name Damageable
extends Node

signal damaged()
signal destroyed()

@export var health: int = 10


func damage(amount: int):
	
	health -= amount
	if health <= 0:
		emit_signal("destroyed")
	else:
		emit_signal("damaged")
