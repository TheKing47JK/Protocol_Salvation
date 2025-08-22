extends Node2D

#Import enemy scene
@export var enemy_scene: PackedScene
@export var count: int = 5
@export var start_x: float = 100
@export var gap: float = 150
@export var y_pos: float = -500
@onready var row_spawn_timer: Timer = $rowtimer

func _ready():
	# Setup timer for 3s
	row_spawn_timer.wait_time = 3.0
	row_spawn_timer.one_shot = true
	add_child(row_spawn_timer)
	row_spawn_timer.timeout.connect(_on_timer_timeout)
	row_spawn_timer.start()
	print("RowSpawner: Timer started, will spawn after 3s")

func _on_timer_timeout():
	#Time up and spawn the enemy
	print("RowSpawner: Timer finished at ", Time.get_ticks_msec() / 1000.0, "s")
	spawn_row()

func spawn_row():
	#Error checking
	if enemy_scene == null:
		push_warning("RowSpawner: No enemy_scene assigned!")
		return
	
	#For loop to spawn 5 enemy
	for i in range(count):
		var enemy: Node2D = enemy_scene.instantiate()
		enemy.position = Vector2(start_x + i * gap, y_pos)
		get_parent().call_deferred("add_child", enemy)
