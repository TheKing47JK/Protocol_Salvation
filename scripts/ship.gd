class_name ShipPlayer
extends CharacterBody2D

signal laser_shoot(laser_scene, location)

@export var armor: int = 4
var max_armor:int = 4

@export var damageInvincibilityTime = 1

@export var normalspeed = 500
@export var boostedspeed = 1000
var speed:int = normalspeed

@export var normalrateOfFire = 0.2
@export var rapidrateOfFire = 0.1
var rateOfFire:float = normalrateOfFire

@onready var muzzle: Marker2D = $Muzzle
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var invincibilityTimer = $"Invincibility Timer"
@onready var rapidfireTimer = $"RapidFire Timer"
@onready var boosterTimer = $"Booster Timer"
@onready var shieldSprite = $Shield

var shoot_cd := false
var laser_scene = preload("res://scenes/laser.tscn")

func _ready():
	Signals.emit_signal("on_player_armor_changed",armor)
	shieldSprite.visible = false


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
	if !(invincibilityTimer.is_stopped()):
		return
		
	applyShield(damageInvincibilityTime)
	armor -= amount
	Signals.emit_signal("on_player_armor_changed",armor)
	if armor <= 0:
		die()

func die():
	queue_free()

func applyShield(time:float):
	invincibilityTimer.start(time + invincibilityTimer.time_left)
	shieldSprite.visible = true
	
func applyRapidFire(time:float):
	rateOfFire = rapidrateOfFire
	rapidfireTimer.start(time + rapidfireTimer.time_left)
	
func applySpeedBoost(time:float):
	speed = boostedspeed
	boosterTimer.start(time + boosterTimer.time_left)
	
func add_armor(amount: int):
	armor += amount
	armor = clamp(armor, 0, max_armor)
	Signals.emit_signal("on_player_armor_changed",armor)

func _on_invincibility_timer_timeout() -> void:
	shieldSprite.visible = false

func _on_rapid_fire_timer_timeout() -> void:
	rateOfFire = normalrateOfFire

func _on_booster_timer_timeout() -> void:
	speed = normalspeed
