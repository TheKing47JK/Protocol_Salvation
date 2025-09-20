extends Node

# Audio player node created at runtime for background music
@onready var player := AudioStreamPlayer.new()

# How long the music should take to fade in when it starts
@export var fade_in_time: float = 0.3
@export var bus: StringName = &"Music"
@export var game_music: AudioStream
@export var target_volume_db: float = -6.0  # ≈ 50% volume

func _ready() -> void:
	# Add the audio player as a child so it will run in the scene tree
	add_child(player)
	player.bus = bus
	# If a music track has been assigned, prepare and play it
	if game_music:
		# Enable looping if the audio resource supports it
		if "loop" in game_music:
			game_music.loop = true
		player.stream = game_music
		# Start silent, then fade in to target volume
		if fade_in_time > 0.0:
			player.volume_db = -40.0
			player.play()
			var tween := create_tween()
			tween.tween_property(player, "volume_db", target_volume_db, fade_in_time)
			await tween.finished
		else:
			# Play instantly at target volume
			player.volume_db = target_volume_db
			player.play()

# Stop the background music, optionally with a fade-out
func stop_bgm(fade_out: float = 0.8) -> void:
	if fade_out <= 0.0:
		# Stop immediately
		player.stop()
		return
	# Fade volume down to silent, then stop playback
	var tween := create_tween()
	tween.tween_property(player, "volume_db", -40.0, fade_out)
	await tween.finished
	player.stop()
	player.volume_db = target_volume_db
