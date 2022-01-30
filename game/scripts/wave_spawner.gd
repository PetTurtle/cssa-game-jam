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
		"name": "Pause the game with [ESC].",
		"attacks": [{"delay": 10,"enemies": []},]
	},
	{
		"name": "CORP wants me to defend this plant.\nMove with [WASD]",
		"attacks": [{"delay": 10,"enemies": []},]
	},
	{
		"name": "It is usually quite, hopefully nothing bad will happen",
		"attacks": [{"delay": 10,"enemies": []},]
	},
	{
		"name": "I can't wait to retire tomorrow!",
		"attacks": [{"delay": 10,"enemies": []},]
	},
	{
		"name": "What is that in the distance?",
		"attacks": [{"delay": 10,"enemies": []},]
	},
	{
		"name": "Oh no!!!",
		"attacks": [{"delay": 10,"enemies": []},]
	},
	{
		"name": "Meteor Shower Incoming!\n Fire with [Left Mouse Button].",
		"attacks": [
			{
				"delay": 10,
				"enemies": [ASTEROID_SMALL, ASTEROID_SMALL, ASTEROID_SMALL]	
			},
		]
	},
	{
		"name": "That was not it!!!\nThere is another wave!",
		"attacks": [
			{
				"delay": 10,
				"enemies": [ASTEROID_SMALL, ASTEROID_SMALL, ASTEROID_MEDIUM]	
			},
			{
				"delay": 20,
				"enemies": [ASTEROID_MEDIUM, ASTEROID_MEDIUM]	
			},
		]
	},
	{
		"name": "There is a big one coming!",
		"attacks": [
			{
				"delay": 10,
				"enemies": [ASTEROID_LARGE, ASTEROID_SMALL, ASTEROID_SMALL]	
			},
			{
				"delay": 30,
				"enemies": [ASTEROID_SMALL, ASTEROID_SMALL]	
			},
		]
	},
	{
		"name": "Where are these things coming from?",
		"attacks": [
			{
				"delay": 10,
				"enemies": [ASTEROID_MEDIUM, ASTEROID_MEDIUM]	
			},
			{
				"delay": 25,
				"enemies": [ASTEROID_SMALL, ASTEROID_SMALL, ASTEROID_SMALL, ASTEROID_SMALL, ASTEROID_SMALL]	
			},
		]
	},
	{
		"name": "Is That... An ALIEN?",
		"attacks": [
			{
				"delay": 10,
				"enemies": [ORBITER]	
			},
			{
				"delay": 25,
				"enemies": [ORBITER, ORBITER, ASTEROID_SMALL, ASTEROID_SMALL, ASTEROID_SMALL]	
			},
			{
				"delay": 35,
				"enemies": [ORBITER, ORBITER, ASTEROID_SMALL, ASTEROID_MEDIUM, ASTEROID_SMALL]	
			},
			{
				"delay": 35,
				"enemies": [ASTEROID_LARGE, ASTEROID_LARGE]	
			},
		]
	},
	{
		"name": "Just my luck... There is more...",
		"attacks": [
			{
				"delay": 10,
				"enemies": [ORBITER, ORBITER, ORBITER, ORBITER, ASTEROID_MEDIUM]	
			},
			{
				"delay": 15,
				"enemies": [ORBITER, ORBITER, ASTEROID_MEDIUM, ASTEROID_MEDIUM, ASTEROID_SMALL]	
			},
			{
				"delay": 20,
				"enemies": [ORBITER, ORBITER, ASTEROID_LARGE, ASTEROID_MEDIUM, ASTEROID_SMALL, ASTEROID_SMALL]	
			},
			{
				"delay": 20,
				"enemies": [ORBITER, ORBITER, ORBITER, ASTEROID_LARGE, ASTEROID_LARGE]	
			},
		]
	},
	{
		"name": "They are sending a fighter squadren!",
		"attacks": [
			{
				"delay": 10,
				"enemies": [FIGHTER, FIGHTER, FIGHTER]	
			},
			{
				"delay": 30,
				"enemies": [FIGHTER, FIGHTER, FIGHTER, ASTEROID_MEDIUM, ASTEROID_MEDIUM, ASTEROID_MEDIUM]	
			},
			{
				"delay": 50,
				"enemies": [ORBITER, ORBITER, ORBITER, FIGHTER, FIGHTER, FIGHTER, ASTEROID_MEDIUM, ASTEROID_MEDIUM]	
			},
			{
				"delay": 50,
				"enemies": [ORBITER, ORBITER, FIGHTER, FIGHTER, FIGHTER, FIGHTER, ASTEROID_MEDIUM, ASTEROID_MEDIUM]	
			},
			{
				"delay": 50,
				"enemies": [ASTEROID_LARGE, ASTEROID_SMALL, ASTEROID_SMALL, ASTEROID_SMALL, ASTEROID_SMALL, ASTEROID_SMALL, ASTEROID_SMALL]	
			},
		]
	},
	{
		"name": "Another One!",
		"attacks": [
			{
				"delay": 10,
				"enemies": [ORBITER, ORBITER, ORBITER, ORBITER, FIGHTER, FIGHTER, FIGHTER, FIGHTER]	
			},
			{
				"delay": 40,
				"enemies": [ORBITER, FIGHTER, FIGHTER, ASTEROID_MEDIUM, ASTEROID_MEDIUM, ASTEROID_MEDIUM]	
			},
			{
				"delay": 40,
				"enemies": [FIGHTER, FIGHTER, FIGHTER, FIGHTER, FIGHTER, FIGHTER, ASTEROID_MEDIUM, ASTEROID_MEDIUM]	
			},
			{
				"delay": 40,
				"enemies": [ORBITER, ORBITER, ORBITER, ORBITER, ORBITER, ORBITER, ASTEROID_MEDIUM, ASTEROID_MEDIUM]	
			},
			{
				"delay": 40,
				"enemies": [ASTEROID_LARGE, ASTEROID_MEDIUM, ASTEROID_MEDIUM, ASTEROID_MEDIUM, ASTEROID_SMALL, ASTEROID_SMALL, ASTEROID_SMALL]	
			},
		]
	},
	{
		"name": "That ship has a BIG gun!",
		"attacks": [
			{
				"delay": 10,
				"enemies": [BATTLESHIP, BATTLESHIP, FIGHTER, FIGHTER, FIGHTER, FIGHTER, FIGHTER, FIGHTER]	
			},
			{
				"delay": 40,
				"enemies": [ORBITER, ORBITER, ORBITER, ORBITER, ORBITER, ORBITER, ORBITER, ORBITER]	
			},
			{
				"delay": 40,
				"enemies": [BATTLESHIP, BATTLESHIP, BATTLESHIP, BATTLESHIP, BATTLESHIP, FIGHTER, FIGHTER, FIGHTER, FIGHTER, FIGHTER]	
			},
			{
				"delay": 40,
				"enemies": [ASTEROID_LARGE, ASTEROID_LARGE, ASTEROID_MEDIUM, ASTEROID_MEDIUM, ASTEROID_MEDIUM, ASTEROID_SMALL, ASTEROID_SMALL, ASTEROID_SMALL, ASTEROID_SMALL, ASTEROID_SMALL]	
			},
		]
	},
	{
		"name": "The Entire fleet is here!",
		"attacks": [
			{
				"delay": 10,
				"enemies": [BOSS, BOSS, BATTLESHIP, BATTLESHIP, BATTLESHIP]	
			},
			{
				"delay": 40,
				"enemies": [ORBITER, ORBITER, ORBITER, ORBITER, ORBITER, ORBITER, ORBITER, ORBITER]	
			},
			{
				"delay": 40,
				"enemies": [BATTLESHIP, BATTLESHIP, FIGHTER, FIGHTER, FIGHTER, FIGHTER, FIGHTER, FIGHTER]	
			},
			{
				"delay": 40,
				"enemies": [ASTEROID_LARGE, ASTEROID_LARGE, ASTEROID_MEDIUM, ASTEROID_MEDIUM, ASTEROID_MEDIUM, ASTEROID_SMALL, ASTEROID_SMALL, ASTEROID_SMALL, ASTEROID_SMALL, ASTEROID_SMALL]	
			},
			{
				"delay": 80,
				"enemies": [ORBITER, ORBITER, FIGHTER, FIGHTER, FIGHTER, FIGHTER, BOSS, BOSS, BOSS, BOSS]	
			},
		]
	},
	{
		"name": "It's finally over!",
		"attacks": [{"delay": 10,"enemies": []},]
	},
]

var wave
var wave_id := 0

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
	if enemy_count == 0 and attack == null:
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
	
	_next_attack()
	if attack:
		delay_timer.start(attack["delay"])
	elif enemy_count == 0:
		_next_wave()
		if wave:
			delay_timer.start(attack["delay"])
		else:
			_victory()


func _victory():
	emit_signal("wave_spawned", "victory")
	emit_signal("victory")
