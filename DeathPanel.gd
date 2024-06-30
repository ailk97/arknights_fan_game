extends Control

func _on_button_pressed():
	get_tree().paused = false
	#get_tree().get_first_node_in_group("player").queue_free()
	get_tree().change_scene_to_file("res://MainMenu.tscn")
	#Engine.time_scale = 1.0
	queue_free()
