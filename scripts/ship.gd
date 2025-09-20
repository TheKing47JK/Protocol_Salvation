class_name ShipPlayer
extends CharacterBody2D

signal laser_shoot(laser_scene, location)
signal died

@export var armor: int = 4


@onready var shoot_sound: AudioStreamPlayer2D = $ShootSound
@onready var hit_sound: AudioStreamPlayer2D = $HitByEnemy

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
	var view_rect := get_viewport_rect()
	position.x = clamp(position.x, 0, view_rect.size.x)
	position.y = clamp(position.y, 0, view_rect.size.y)
	move_and_slide()

func shoot():
	laser_shoot.emit(laser_scene, muzzle.global_position)
	# If a shooting sound exists, play it (restart if it is already playing)
	if shoot_sound:
		if shoot_sound.playing:
			shoot_sound.stop()
		shoot_sound.play()

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
	Signals.emit_signal("on_player_armor_changed", armor)
	
# If a hit sound exists, play it
	if hit_sound:
		if hit_sound.playing:
			hit_sound.stop()
		hit_sound.play()
  
	
	if armor <= 0:
		die()

func die():
	# Load the explosion scene for the ship
	var explosion_scene = preload("res://scenes/explosion_ship.tscn")
	# Create an instance of the explosion and place it at the ship's position
	var explosion = explosion_scene.instantiate()
	explosion.global_position = global_position
	get_parent().add_child(explosion)
	queue_free()
	# Emit a custom signal to notify other scripts that this entity has died
	died.emit()


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
	
