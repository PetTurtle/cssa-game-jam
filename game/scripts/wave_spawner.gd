class_name WaveSpawner
extends Node

signal victory()
signal wave_spawned(name)

const SPAWN_DISTANCE = 400

const ASTEROID_SMALL = 0
const ASTEROID_MEDIUM = 1
const ASTEROID_LARGE = 2
const ORBITER = 3
const FIGHTER = 4
const BATTLESHIP = 5
const BOSS = 6

var enemies = [
	preload("res://scenes/enemies/asteroid/asteroid_small.tscn"),
	preload("res://scenes/enemies/asteroid/asteroid_med.tscn"),
	preload("res://scenes/enemies/asteroid/asteroid_large.tscn"),
	preload("res://scenes/enemies/orbiter/orbiter.tscn"),
	preload("res://scenes/enemies/fighter/fighter.tscn"),
	preload("res://scenes/enemies/battleship/battleship.tscn"),
	preload("res://scenes/enemies/boss/boss.tscn")
]


var waves = [
	{
		"name": "Pause the game with [Space].",
		"attacks": [{"delay": 10,"enemies": []},]
	},
	{
		"name": "What a nice planet! Hopefully no one will invaid it!\n Move with [WASD]",
		"attacks": [{"delay": 10,"enemies": []},]
	},
	{
		"name": "What is that in the distance? Could it be?",
		"attacks": [{"delay": 10,"enemies": []},]
	},
	{
		"name": "Meteor Shower Incoming!\n Fire with [Left Mouse Button].",
		"attacks": [
			{
				"delay": 10,
				"enemies": [ASTEROID_SMALL, ASTEROID_SMALL, ASTEROID_SMALL, ASTEROID_MEDIUM]	
			},
		]
	},
	{
		"name": "Meteor Shower Incoming!",
		"attacks": [
			{
				"delay": 10,
				"enemies": [ASTEROID_SMALL, ASTEROID_SMALL, ASTEROID_SMALL, ASTEROID_MEDIUM]	
			},
		]
	},
]

var wave
var wave_id := 3

var attack
var attack_id := 0

var enemy_count := 0

@onready var delay_timer: Timer = $DelayTimer
@onready var game: Game = get_tree().current_scene

func _ready():
	wave = waves[wave_id]
	attack = wave["attacks"][attack_id]
	emit_signal("wave_spawned", wave["name"])
	delay_timer.start(attack["delay"])


func enemy_died():
	enemy_count -= 1
	if enemy_count == 0:
		_next_attack()
		if attack:
			delay_timer.start(attack["delay"])
		else:
			_next_wave()
			if wave:
				delay_timer.start(attack["delay"])
			else:
				_victory()


func _next_wave():
	wave_id += 1
	if waves.size() > wave_id:
		wave = waves[wave_id]
		attack_id = 0
		attack = wave["attacks"][attack_id]
		emit_signal("wave_spawned", wave["name"])
	else:
		wave = null


func _next_attack():
	attack_id += 1
	if wave["attacks"].size() > attack_id:
		attack = wave["attacks"][attack_id]
	else:
		attack = null


func _spawn_enemy(scene: PackedScene):
	randomize()
	var spawn_vector = (Vector2.LEFT * SPAWN_DISTANCE).rotated(randf_range(0, 2 * PI)) + game.gravity.position
	var enemy = scene.instantiate()
	game.add_child(enemy)
	enemy.global_position = spawn_vector
	var counter := SpawnCounter.new(self)
	enemy.add_child(counter)
	enemy_count += 1


func _on_delay_timer_timeout():
	for enemy_id in attack["enemies"]:
		_spawn_enemy(enemies[enemy_id])
	
	if enemy_count == 0:
		_next_attack()
		if attack:
			delay_timer.start(attack["delay"])
		else:
			_next_wave()
			if wave:
				delay_timer.start(attack["delay"])
			else:
				_victory()


func _victory():
	emit_signal("wave_spawned", "victory")
	emit_signal("victory")
