extends Node2D

@onready var ship: CharacterBody2D = $Ship
@onready var player_spawn_position: Marker2D = $PlayerSpawnPosition
@onready var laser_container: Node2D = $LaserContainer
@onready var enemy_spawn_timer: Timer = $EnemySpawnTimer
@onready var enemy_container: Node2D = $EnemyContainer

@export var enemy_scenes: Array[PackedScene] = []

var easy_enemies: Array[PackedScene] = []
var medium_enemies: Array[PackedScene] = []
var hard_enemies: Array[PackedScene] = []
var game_start_time: float = 0.0
var easy_weight := 1.0
var medium_weight := 0.0
var hard_weight := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ship.global_position = player_spawn_position.global_position
	ship.laser_shoot.connect(laser_shot)
	easy_enemies = [enemy_scenes[0]]
	medium_enemies = [enemy_scenes[1]]
	hard_enemies = [enemy_scenes[2]]
	enemy_spawn_timer.wait_time = randf_range(2.0, 3.0) 
	game_start_time = Time.get_ticks_msec() / 1000.0
	ship.died.connect(_on_player_died)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
		
	var time_passed = Time.get_ticks_msec() / 1000.0 - game_start_time

	if time_passed > 30 and enemy_spawn_timer.wait_time > 1.5:
		enemy_spawn_timer.wait_time = 2.0

	# just for a testing the scene transition effect
	# press 'enter'
	if Input.is_action_just_pressed("stageChange"):
		stageManager.next_stage()

func laser_shot(laser_scene,location):
	var laser = laser_scene.instantiate()
	laser.global_position = location
	laser_container.add_child(laser)
	
func laser_enemy_shot(laser_enemy_scene, location):
	var laser = laser_enemy_scene.instantiate()
	laser.global_position = location
	laser_container.add_child(laser)

func _on_enemy_spawn_timer_timeout() -> void:

	var current_time = Time.get_ticks_msec() / 1000.0
	var time_passed = current_time - game_start_time

	var available_enemies = []

	if time_passed < 3:
		available_enemies = easy_enemies
	elif time_passed < 6:
		available_enemies = easy_enemies + medium_enemies
	else:
		available_enemies = easy_enemies + medium_enemies + hard_enemies

	var enemy_scene = available_enemies.pick_random()
	var enemy = enemy_scene.instantiate()

	if enemy.has_signal("laser_enemy_shoot"):
		enemy.laser_enemy_shoot.connect(laser_enemy_shot)

	enemy.global_position = Vector2(randf_range(50, 700), -50)
	#enemy_container.add_child(enemy)

func update_weights():
	var time_passed = (Time.get_ticks_msec() / 1000.0) - game_start_time

	easy_weight = clamp(1.0 - time_passed / 60.0, 0.2, 1.0)
	medium_weight = clamp(time_passed / 60.0, 0.0, 1.0)
	hard_weight = clamp((time_passed - 60.0) / 60.0, 0.0, 1.0)

func get_weighted_enemy_scene() -> PackedScene:
	update_weights()

	var total = easy_weight + medium_weight + hard_weight
	var rand_val = randf() * total

	if rand_val < easy_weight:
		return easy_enemies.pick_random()
	elif rand_val < easy_weight + medium_weight:
		return medium_enemies.pick_random()
	else:
		return hard_enemies.pick_random()
		
func _on_player_died():
	# When the player dies, restart the main stage
	TransitionManager.transition_to("res://stage/stage_main.tscn")

		
