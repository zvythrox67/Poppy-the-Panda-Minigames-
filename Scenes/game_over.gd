extends Node2D

func _ready():
	pass

func _on_quit_pressed():
	get_tree().quit()

func _on_tryagain_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/game_1.tscn")
