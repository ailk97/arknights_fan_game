extends CanvasLayer

func _ready():
	$Panel/Master.value = AudioServer.get_bus_volume_db(0)
	$Panel/UI.value = AudioServer.get_bus_volume_db(2)
	$Panel/Music.value = AudioServer.get_bus_volume_db(3)
	$Panel/SFX.value = AudioServer.get_bus_volume_db(1)

func _on_texture_button_pressed():
	get_tree().change_scene_to_file("res://MainMenu.tscn")


func _on_master_value_changed(value):
	AudioServer.set_bus_volume_db(0, value)
	print(AudioServer.get_bus_volume_db(0))
func _on_ui_value_changed(value):
	AudioServer.set_bus_volume_db(2, value)
	print(AudioServer.get_bus_volume_db(2))
func _on_music_value_changed(value):
	AudioServer.set_bus_volume_db(3, value)
	print(AudioServer.get_bus_volume_db(3))
func _on_sfx_value_changed(value):
	AudioServer.set_bus_volume_db(1, value)
	print(AudioServer.get_bus_volume_db(1))


func _process(delta):
	$Panel/Master/Label.text = str($Panel/Master.value)
	$Panel/UI/Label.text = str($Panel/UI.value)
	$Panel/Music/Label.text = str($Panel/Music.value)
	$Panel/SFX/Label.text = str($Panel/SFX.value)


func _on_save_pressed():
	var audioDB = [AudioServer.get_bus_volume_db(0), AudioServer.get_bus_volume_db(2), AudioServer.get_bus_volume_db(3), AudioServer.get_bus_volume_db(1)]
	var audio = JSON.new()
	audio.set_data(audioDB)
	ResourceSaver.save(audio, "user://audioSettings.json")
	
	var new_settings = ConfigFile.new()
	new_settings.set_value("lang", "lang", Events.lang)
	new_settings.save("user://settings.ini")
	
	$SaveGood.visible = true


func _on_reset_pressed():
	var audioDB = load("user://audioSettings.json")
	if audioDB != null:
		AudioServer.set_bus_volume_db(0, audioDB.data[0])
		AudioServer.set_bus_volume_db(2, audioDB.data[1])
		AudioServer.set_bus_volume_db(3, audioDB.data[2])
		AudioServer.set_bus_volume_db(1, audioDB.data[3])
		$Panel/Master.value = AudioServer.get_bus_volume_db(0)
		$Panel/UI.value = AudioServer.get_bus_volume_db(2)
		$Panel/Music.value = AudioServer.get_bus_volume_db(3)
		$Panel/SFX.value = AudioServer.get_bus_volume_db(1)


func _on_current_lang_id_pressed(id):
	print(id)
	Events.lang_update(id)
	#$Panel/lang/current_lang.name = Events.lang
