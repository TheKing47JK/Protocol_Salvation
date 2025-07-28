class_name ShipPlayer
extends CharacterBody2D

signal laser_shoot(laser_scene, location)
signal armor_changed

@export var armor: int = 4
@export var speed = 500
@export var rateOfFire = 0.25

@onready var muzzle: Marker2D = $Muzzle
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var shoot_cd := false
var laser_scene = preload("res://scenes/laser.tscn")


func _process(_delta: float) -> void:
	if Input.is_action_pressed("shoot") and not shoot_cd:
		shoot_cd = true
		shoot()
		await get_tree().create_timer(rateOfFire).timeout
		shoot_cd = false
	animate_the_ship()


func _physics_process(_delta: float) -> void:
	var direction = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	)
	velocity = direction * speed
	var viewRect := get_viewport_rect()
	position.x = clamp(position.x, 0, viewRect.size.x)
	position.y = clamp(position.y, 0, viewRect.size.y)
	move_and_slide()
	
func shoot():
	laser_shoot.emit(laser_scene, muzzle.global_position)


func animate_the_ship() -> void:
	if Input.is_action_pressed("move_right"):
		animated_sprite_2d.play("move_right")
	elif Input.is_action_pressed("move_left"):
		animated_sprite_2d.play("move_left")
	else:
		animated_sprite_2d.play("center")

func take_damage(amount: int) -> void:
	armor -= amount
	armor_changed.emit(armor)
	if armor <= 0:
		die()

func die():
	queue_free()
