extends Node2D

# Enemy container (node in your scene where enemies will be added)
@onready var enemy_container: Node2D = $EnemyContainer
@onready var laser_container: Node2D = $LaserContainer

# Enemy scene dictionary
@export var enemy_scenes := {
	"normal": preload("res://scenes/enemy_1.tscn"),
	"kamikaze": preload("res://scenes/enemy_2.tscn"),
	"splitting": preload("res://scenes/enemy_3.tscn"),
	"bouncing" : preload("res://scenes/bouncing.tscn"),
	"miniboss" : preload("res://scenes/mini_boss.tscn")
}

# Wave data
var stages: Array = []
var current_stage := 0
var current_wave := 0
var spawn_timer: Timer

func laser_enemy_shot(laser_enemy_scene, location):
	var laser = laser_enemy_scene.instantiate()
	laser.global_position = location
	laser_container.add_child(laser)

func _ready():
	# Load waves.json
	var file := FileAccess.open("res://waves.json", FileAccess.READ)
	if file:
		var parsed = JSON.parse_string(file.get_as_text())
		if typeof(parsed) == TYPE_DICTIONARY:
			stages = parsed["stages"]
		file.close()

	# Create and setup timer
	spawn_timer = Timer.new()
	spawn_timer.one_shot = true
	add_child(spawn_timer)
	spawn_timer.timeout.connect(_on_spawn_wave)

	# Start first wave
	start_next_wave()


func start_next_wave():
	if current_stage >= stages.size():
		print("All stages complete!")
		return

	var waves = stages[current_stage]["waves"]

	if current_wave < waves.size():
		var wave = waves[current_wave]
		print("Starting wave: ", current_wave, " (", wave["type"], ")")
		spawn_timer.wait_time = wave.get("delay", 3.0)
		spawn_timer.start()
	else:
		print("Stage ", current_stage, " cleared!")
		current_stage += 1
		current_wave = 0
		start_next_wave()


func _on_spawn_wave():
	var waves = stages[current_stage]["waves"]
	var wave = waves[current_wave]

	match wave["type"]:
		"row":
			spawn_row(wave)
		"line":
			spawn_line(wave)
		"v-shape":
			spawn_v(wave)
		"boss":
			spawn_enemy("boss", Vector2(640, -300)) # Center spawn for boss
		_:
			print("Unknown wave type: ", wave["type"])

	current_wave += 1
	start_next_wave()


func spawn_row(wave: Dictionary):
	var enemies: Array = wave.get("enemies", []) # list of enemy types
	var count : int = wave.get("count", 1)
	var viewport_rect = get_viewport_rect()
	var start_x = wave.get("start_x", 400)
	var screen_min_x = viewport_rect.position.x + 50   # add some padding
	var screen_max_x = viewport_rect.end.x - 50        # add some padding
	var spacing = 96  # adjust spacing between bots
	
	var enemy_index = 0  

	for enemy_type in enemies:
		for i in range(count):
			# Calculate X position based on enemy_index
			var offset_x = start_x + screen_min_x + enemy_index * spacing
			offset_x = clamp(offset_x, screen_min_x, screen_max_x)
			if offset_x > screen_max_x:
				offset_x = screen_min_x  # wrap around if too far right

			var spawn_position = Vector2(offset_x, -50)
			spawn_enemy(enemy_type, spawn_position)

			enemy_index += 1

# Vertical line spawner
func spawn_line(wave: Dictionary):
	var enemies: Array = wave.get("enemies", [])
	var count : int = wave.get("count", 1)
	var viewport_rect = get_viewport_rect()
	var start_y = wave.get("start_y", -300)  # starting height
	var screen_min_y = viewport_rect.position.y + 50
	var screen_max_y = viewport_rect.end.y - 200
	var spacing = 96
	var start_x = wave.get("x", viewport_rect.size.x / 2) # middle by default

	var enemy_index = 0

	for enemy_type in enemies:
		for i in range(count):
			var offset_y = start_y + screen_min_y + enemy_index * spacing
			#offset_y = clamp(offset_y, screen_min_y, screen_max_y)

			var spawn_position = Vector2(start_x, offset_y)
			spawn_enemy(enemy_type, spawn_position)
			enemy_index += 1
			
func spawn_v(wave: Dictionary):
	var enemies: Array = wave.get("enemies", [])
	var count : int = wave.get("count", 1)
	var viewport_rect = get_viewport_rect()
	var center_x = viewport_rect.size.x / 2
	var screen_min_x = viewport_rect.position.x + 50   # add some padding
	var screen_max_x = viewport_rect.end.x - 50        # add some padding
	var spacing_x = 80
	var spacing_y = 80

	var enemy_index = 0

	# calculate max depth of the V
	var max_depth = int(ceil(float(count) / 2)) * spacing_y
	# start high enough so the last enemy is still above the screen
	var start_y = -max_depth - 100

	for enemy_type in enemies:
		for i in range(count):
			# Alternate left/right
			var direction = 1 if enemy_index % 2 == 0 else -1
			var step = int((enemy_index + 1) / 2)
			var offset_x = center_x + direction * (spacing_x * step)
			var offset_y = start_y + spacing_y * step
			offset_x = clamp(offset_x, screen_min_x, screen_max_x)
			var spawn_position = Vector2(offset_x, offset_y)
			spawn_enemy(enemy_type, spawn_position)

			enemy_index += 1

func spawn_enemy(enemy_type: String, pos: Vector2 = Vector2.ZERO):
	if not enemy_scenes.has(enemy_type):
		push_warning("Unknown enemy type: %s" % enemy_type)
		return

	var enemy = enemy_scenes[enemy_type].instantiate()
	enemy.position = pos
	if enemy.has_signal("laser_enemy_shoot"):
		enemy.laser_enemy_shoot.connect(laser_enemy_shot)
	enemy_container.add_child(enemy)
	print("Spawned ", enemy_type, " at ", pos)
