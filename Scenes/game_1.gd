extends Node2D

@onready var timer_text = $Background/TimerText
@onready var lives_text = $Background/LivesText

var time_left = 10
var thorns_removed = 0
var total_thorns = 10
var timer_running = true

func _ready():
	update_lives()
	
	for thorn in get_tree().get_nodes_in_group("throns"):
		thorn.pressed.connect(_on_thorn_pressed.bind(thorn))
		
		countdown()

func update_lives():
	lives_text.text = str(Global.lives) + " lives"
	
func countdown():
	while time_left > 0 and timer_running:
		timer_text.text = str(ceil(time_left))
		await get_tree().create_timer(0.1).timeout
		time_left -= 0.1
		
	if timer_running:
		Global.lives -= 1
		
		if Global.lives <= 0:
			get_tree().change_scene_to_file("res://scenes/game_over.tscn")
		else:
			get_tree().change_scene_to_file("res://scenes/game_1.tscn")
			
func _on_thorn_pressed(thorn):
	if not timer_running or not thorn.visible:
		return
		
	thorn.visible = false
	thorns_removed += 1
	
	if thorns_removed >= total_thorns:
		timer_running = false
		timer_text.text = "Level Completed"
		await get_tree().create_timer(1.0).timeout
		
		Global.minigames_done += 1
		get_tree().change_scene_to_file("res://scenes/level_screen.tscn")
		
