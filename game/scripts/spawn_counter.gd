class_name SpawnCounter
extends Node

var spawner: WaveSpawner

func _init(_spawner: WaveSpawner):
	spawner = _spawner

func _exit_tree():
	spawner.enemy_died()
