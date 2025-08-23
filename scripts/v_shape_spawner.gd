extends Node2D

@export var enemy_scene: PackedScene
@export var count_per_side: int = 5
@export var spacing: float = 80.0
@export var vertical_spacing: float = 60.0
@export var start_offset: float = -900.0   # start offscreen
@export var spawn_delay: float = 0.2       # seconds between spawns
@export var start_x: int = 380
@export var start_y: int = -800
@export var initial_wait: float = 15.0      # wait before spawning starts

var spawn_timer: Timer
var delay_timer: Timer

var spawn_positions: Array = []
var spawn_index: int = 0

func _ready():
	_prepare_spawn_order()
	
	# Delay timer (3s before spawning starts)
	delay_timer = Timer.new()
	delay_timer.wait_time = initial_wait
	delay_timer.one_shot = true
	add_child(delay_timer)
	delay_timer.timeout.connect(_start_spawning)
	delay_timer.start()


func _prepare_spawn_order():
	spawn_positions.clear()
	var base_y = position.y
	var base_x = position.x + start_x
	
	# Left wing of V
	for i in range(count_per_side):
		var pos = Vector2(base_x - spacing * i, base_y + vertical_spacing * i + start_x + start_y)
		spawn_positions.append(pos)
	
	# Right wing of V
	for i in range(count_per_side):
		var pos = Vector2(base_x + spacing * i, base_y + vertical_spacing * i + start_offset + start_x)
		spawn_positions.append(pos)
	
	spawn_index = 0


func _start_spawning():
	# Spawning timer (after delay)
	spawn_timer = Timer.new()
	spawn_timer.wait_time = spawn_delay
	spawn_timer.autostart = true
	spawn_timer.one_shot = false
	add_child(spawn_timer)
	spawn_timer.timeout.connect(spawn_step)


func spawn_step():
	if spawn_index >= spawn_positions.size():
		spawn_timer.stop()
		return
	
	if enemy_scene:
		var enemy = enemy_scene.instantiate()
		get_parent().add_child(enemy)
		enemy.position = spawn_positions[spawn_index]
	
	spawn_index += 1
