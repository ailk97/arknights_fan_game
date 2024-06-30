extends CanvasLayer

func _on_texture_button_pressed():
	get_tree().change_scene_to_file("res://MainMenu.tscn")


func _on_load_1_pressed():
	var purp = $Panel/HBoxContainer/Save1.name
	loadSave(purp)

func _on_load_2_pressed():
	var purp = $Panel/HBoxContainer/Save2.name
	loadSave(purp)

func _on_load_3_pressed():
	var purp = $Panel/HBoxContainer/Save3.name
	loadSave(purp)

func loadSave(saveName):
	Events.new_save = false
	Events.dungeon1_generated = false
	Events.activeSave = saveName
	$blackScreen.modulate.a = 0
	while not $blackScreen.modulate.a >= 1:
		$blackScreen.modulate.a += 0.05
		await get_tree().create_timer(0.01).timeout
	print(saveName)
	SceneLoader.sceneChange("res://1.tscn")
