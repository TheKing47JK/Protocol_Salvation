extends Node2D
@onready var button: Button = %Button
@onready var button_2: Button = %Button2
@onready var button_3: Button = %Button3
@onready var lv_1_lock: ColorRect = $Lv1_lock
@onready var lv_2_lock: ColorRect = $lv2_lock
@onready var lv_3_lock: ColorRect = $lv3_lock
@onready var lock_1: Sprite2D = $Lock1
@onready var lock_2: Sprite2D = $Lock2

func _ready() -> void:
	button.grab_focus()
	
