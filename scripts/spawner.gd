extends Node2D

@onready var enemy_container: Node2D = $EnemyContainer
@onready var laser_container: Node2D = $LaserContainer

# === Enemy scenes ===
@export var row_enemy_scene: PackedScene
@export var line_enemy_scene: PackedScene
@export var v_enemy_scene: PackedScene

# === Row spawn settings ===
@export var row_count: int = 5
@export var row_start_x: float = 100
@export var row_gap: float = 150
@export var row_y_pos: float = -300

# === Line spawn settings ===
@export var line_count: int = 5
@export var line_start_y: float = -1000
@export var line_gap: float = 150
@export var line_x_pos: float = 400

# === V-shape spawn settings ===
@export var v_count_per_side: int = 5
@export var v_spacing: float = 80
@export var v_vertical_spacing: float = 60
@export var v_start_offset: float = -900
@export var v_start_x: int = 380
@export var v_start_y: int = -800
@export var v_initial_wait: float = 15.0
@export var v_spawn_delay: float = 0.2

# === Spawn schedule (seconds) ===
@export var row_delay: float = 5.0
@export var line_delay: float = 10.0
@export var v_delay: float = 17.0

# Internal
var v_spawn_positions: Array = []
var v_spawn_index: int = 0
var v_spawn_timer: Timer

func _ready() -> void:
	# Schedule spawns using await
	await get_tree().create_timer(row_delay).timeout
	spawn_row()
	
	await get_tree().create_timer(line_delay - row_delay).timeout
	spawn_line()
	
	await get_tree().create_timer(v_delay - line_delay).timeout
	prepare_v_spawn()
	start_v_spawn()

func laser_enemy_shot(laser_enemy_scene, location):
	var laser = laser_enemy_scene.instantiate()
	laser.global_position = location
	laser_container.add_child(laser)

# -------------------- Row spawn --------------------
func spawn_row():
	if row_enemy_scene == null:
		push_warning("No row_enemy_scene assigned!")
		return
	
	var container = Node2D.new()
	add_child(container)  # optional container for organization
	
	for i in range(row_count):
		var enemy = row_enemy_scene.instantiate()
		if enemy.has_signal("laser_enemy_shoot"):
			enemy.laser_enemy_shoot.connect(laser_enemy_shot)
		enemy.position = Vector2(row_start_x + i * row_gap, row_y_pos)
		enemy_container.add_child(enemy)
		print("Row spawned enemy at: ", enemy.position)


# -------------------- Line spawn --------------------
func spawn_line():
	if line_enemy_scene == null:
		push_warning("No line_enemy_scene assigned!")
		return
	
	var container = Node2D.new()
	add_child(container)  # optional container for organization
	
	for i in range(line_count):
		var enemy = line_enemy_scene.instantiate()
		if enemy.has_signal("laser_enemy_shoot"):
			enemy.laser_enemy_shoot.connect(laser_enemy_shot)
		enemy.position = Vector2(line_x_pos, line_start_y + i * line_gap)
		enemy_container.add_child(enemy)
		print("Line spawned enemy at: ", enemy.position)


# -------------------- V-shape spawn --------------------
func prepare_v_spawn():
	if v_enemy_scene == null:
		push_warning("No v_enemy_scene assigned!")
		return
	
	v_spawn_positions.clear()
	var base_x = v_start_x
	var base_y = v_start_y
	
	# Left wing
	for i in range(v_count_per_side):
		var pos = Vector2(base_x - v_spacing * i, base_y + v_vertical_spacing * i)
		v_spawn_positions.append(pos)
	
	# Right wing
	for i in range(v_count_per_side):
		var pos = Vector2(base_x + v_spacing * i, base_y + v_vertical_spacing * i)
		v_spawn_positions.append(pos)
	
	v_spawn_index = 0


func start_v_spawn():
	v_spawn_timer = Timer.new()
	v_spawn_timer.wait_time = v_spawn_delay
	v_spawn_timer.one_shot = false
	v_spawn_timer.autostart = true
	add_child(v_spawn_timer)
	v_spawn_timer.timeout.connect(_v_spawn_step)


func _v_spawn_step():
	if v_spawn_index >= v_spawn_positions.size():
		v_spawn_timer.stop()
		v_spawn_timer.queue_free()
		return
	
	var enemy = v_enemy_scene.instantiate()
	enemy.position = v_spawn_positions[v_spawn_index]
	if enemy.has_signal("laser_enemy_shoot"):
		enemy.laser_enemy_shoot.connect(laser_enemy_shot)
	enemy_container.add_child(enemy)
	v_spawn_index += 1
