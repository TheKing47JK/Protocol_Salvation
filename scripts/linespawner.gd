extends Node2D

@export var enemy_scene: PackedScene        
@export var count: int = 5
@export var start_y: float = -1000
@export var gap: float = 150
@export var x_pos: float = 200
@onready var line_spawn_timer: Timer = $linetimer

func _ready():
	# Setup timer
	line_spawn_timer.wait_time = 3.0
	line_spawn_timer.one_shot = true
	add_child(line_spawn_timer)
	line_spawn_timer.timeout.connect(_on_timer_timeout)
	line_spawn_timer.start()
	print("RowSpawner: Timer started, will spawn after 3s")

func _on_timer_timeout():
	print("RowSpawner: Timer finished at ", Time.get_ticks_msec() / 1000.0, "s")
	spawn_line()
	
func spawn_line():
	if enemy_scene == null:
		push_warning("LineSpawner: No enemy_scene assigned!")
		return

	for i in range(count):
		var enemy: Node2D = enemy_scene.instantiate()
		enemy.position = Vector2(x_pos, start_y + i * gap)
		get_parent().call_deferred("add_child", enemy)
