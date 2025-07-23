extends Area2D

@export var speed:float = 100
var velocity := Vector2(0,0)

func _physics_process(delta):
	var dirVec := Vector2(0,0)
	if Input.is_action_pressed("move_left"):
		dirVec.x = -1
	elif Input.is_action_pressed("move_right"):
		dirVec.x = 1
	if Input.is_action_pressed("move_up"):
		dirVec.y = -1
	elif Input.is_action_pressed("move_down"):
		dirVec.y = 1
		
	velocity = dirVec.normalized() * speed
	position += velocity * delta
	
	#make sure the player cannot go out of screen
	var viewRect :=get_viewport_rect()
	position.x = clamp(position.x,0,viewRect.size.x)
	position.y = clamp(position.y,0,viewRect.size.y)
