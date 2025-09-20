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
	
	#LEVEL1 logic
	if stageManager.lvl1_completed == true:
		lv_1_lock.visible = false
		lock_1.visible = false
	if stageManager.lvl1_completed == false:
		lv_1_lock.visible = true
		lock_1.visible = true
	
	#LEVEL2 logic
	if stageManager.lvl2_completed == true:
		lv_2_lock.visible = false
		lock_2.visible = false
	if stageManager.lvl2_completed == false:
		lv_2_lock.visible = true
		lock_2.visible = true
		
	#LEVEL2 logic
	if stageManager.lvl3_completed == true:
		lv_3_lock.visible = false
	if stageManager.lvl3_completed == false:
		lv_3_lock.visible = true

func _on_button_pressed() -> void:
	if stageManager.lvl1_completed == false:
		stageManager.load_stage(0)
	else:
		stageManager.load_stage(0)
		
		


func _on_button_2_pressed() -> void:
	if stageManager.lvl1_completed == false:
		null
	if stageManager.lvl1_completed == true:
		stageManager.load_stage(1)



func _on_button_3_pressed() -> void:
	if stageManager.lvl2_completed == false:
		null
	if stageManager.lvl2_completed == true:
		stageManager.load_stage(2)
