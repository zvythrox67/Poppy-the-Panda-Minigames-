extends Node2D

@onready var timer_text = $Background/TimerText
@onready var lives_text = $Background/LivesText

var time_left = 10.0
var thorns_removed = 0
var total_thorns = 10
var timer_running = true

func _ready():
	update_lives()
	
	for i in range(1, total_thorns + 1):
		var thorn_node = get_node_or_null("Background/Thorn" + str(i))
		if thorn_node:
			thorn_node.pressed.connect(_on_thorn_pressed.bind(thorn_node))
			
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
			get_tree().change_scene_to_file("res://Scenes/game_over.tscn")
		else:
			get_tree().change_scene_to_file("res://Scenes/level_screen.tscn")

func _on_thorn_pressed(thorn: TextureButton):
	if not timer_running or not thorn.visible:
		return
	
	thorn.hide()
	
	thorns_removed += 1
	print("Thorn removed: " + thorn.name + " (" + str(thorns_removed) + "/" + str(total_thorns) + ")")
	
	if thorns_removed >= total_thorns:
		timer_running = false
		timer_text.text = "Level Completed!"
		print("ALL THORNS REMOVED!")
		await get_tree().create_timer(1.0).timeout
		
		Global.minigames_done += 1
		get_tree().change_scene_to_file("res://Scenes/level_complete_cactus.tscn")
