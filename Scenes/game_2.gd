extends Node2D

@onready var timer_text = $Background/TimerText
@onready var lives_text = $Background/LivesText
@onready var panda = $Background/Panda

var time_left = 15.0
var panda_speed = 10.0 
var panda_position = 0.0
var max_position = 350.0
var timer_running = true
var swim_frame = 0
var game_won = false

func _ready():
	update_lives()
	panda.texture = load("res://Images/panda1.png")
	panda.position.x = 100
	countdown()

func update_lives():
	lives_text.text = str(Global.lives) + " Lives"

func countdown():
	while time_left > 0 and timer_running:
		timer_text.text = str(ceil(time_left))
		await get_tree().create_timer(0.1).timeout
		time_left -= 0.1
	
	if timer_running and not game_won:
		Global.lives -= 1
		if Global.lives <= 0:
			get_tree().change_scene_to_file("res://Scenes/game_over.tscn")
		else:
			get_tree().change_scene_to_file("res://Scenes/level_screen.tscn")

func _input(event):
	if not timer_running or game_won:
		return
	
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		swim()

func swim():
	if not timer_running or game_won:
		return
	
	panda_position += panda_speed
	panda.position.x = 100 + panda_position
	
	swim_frame += 1
	if swim_frame % 2 == 0:
		panda.texture = load("res://Images/panda1.png")
	else:
		panda.texture = load("res://Images/panda2.png")
	
	if panda_position >= max_position and not game_won:
		win_game()

func win_game():
	game_won = true
	timer_running = false
	panda.texture = load("res://Images/panda3.png")
	timer_text.text = "LEVEL COMPLETE!"
	await get_tree().create_timer(1.5).timeout
	
	Global.minigames_done += 1
	get_tree().change_scene_to_file("res://Scenes/level_screen.tscn")
