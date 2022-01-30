extends RigidDynamicBody2D

var weapons = [
	"res://scenes/weapons/rifle/rifle.tscn",
	"res://scenes/weapons/rpg/rpg.tscn",
	"res://scenes/weapons/shotgun/shotgun.tscn",
	"res://scenes/weapons/smg/smg.tscn",
	"res://scenes/weapons/sniper/sniper.tscn",
]

var weapon_sprites = [
	"res://scenes/weapons/rifle/rifle.png",
	"res://scenes/weapons/rpg/rpg.png",
	"res://scenes/weapons/shotgun/shotgun.png",
	"res://scenes/weapons/smg/smg.png",
	"res://scenes/weapons/sniper/sniper.png",
]

var weapon_id := 0

@onready var game: Game = get_tree().current_scene
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready():
	weapon_id = randi_range(0, weapons.size()-1)
	$Drop.texture = load(weapon_sprites[weapon_id])


func _physics_process(delta):
	if $Para.visible:
		look_at(game.gravity.global_position)
		rotation -= PI/2
	var gravity_dir := global_position.direction_to(game.get_gravity_point()).normalized()
	apply_central_force(gravity_dir * gravity * mass * delta)


func _on_drop_body_entered(body):
	$Para.visible = false


func _on_pickup_body_entered(body):
	body.change_weapon(weapons[weapon_id])
	queue_free()
