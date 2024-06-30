extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	if FileAccess.file_exists("user://Save/Save0/СharData.res") == true:
		$Button/Continue.visible = true


func _on_button_pressed():
	$NameSelector.visible = true
	Events.new_save = true
	get_tree().paused = true
	#Events.new_save = true
	#Events.dungeon1_generated = false
	#get_tree().change_scene_to_file("res://1.tscn")

func _on_button_2_pressed():
	get_tree().change_scene_to_file("res://loading.tscn")

func _on_continue_pressed():
	$Button.disabled = true
	$Button/Continue.disabled = true
	$Button2.disabled = true
	$Button3.disabled = true
	$Button4.disabled = true
	$blackScreen.modulate.a = 0
	while not $blackScreen.modulate.a >= 1:
		$blackScreen.modulate.a += 0.05
		$AudioStreamPlayer.volume_db -= 1
		await get_tree().create_timer(0.01).timeout
	Events.new_save = false
	Events.dungeon1_generated = false
	Events.can_use = false
	SceneLoader.sceneChange("res://1.tscn")

func _on_line_edit_text_submitted(_new_text):
	_on_next_pressed()
func _on_next_pressed():
	if $NameSelector/LineEdit.text != "":
		$Button.disabled = true
		$Button/Continue.disabled = true
		$Button2.disabled = true
		$Button3.disabled = true
		$Button4.disabled = true
		$Button5.disabled = true
		$NameSelector/Next.disabled = true
		if not $NameSelector/LineEdit.text == "":
			print($NameSelector/LineEdit.text)
			get_tree().paused = false
			$blackScreen.modulate.a = 0
			while not $blackScreen.modulate.a >= 1:
				$blackScreen.modulate.a += 0.05
				await get_tree().create_timer(0.01).timeout
			Events.playerName = $NameSelector/LineEdit.text
			Events.new_save = true
			Events.dungeon1_generated = false
			SceneLoader.sceneChange("res://1.tscn")
	else:
		return

func _on_button_3_pressed():
	$Button.disabled = true
	$Button/Continue.disabled = true
	$Button2.disabled = true
	$Button3.disabled = true
	$Button4.disabled = true
	$Button5.disabled = true
	$blackScreen.modulate.a = 0
	while not $blackScreen.modulate.a >= 1:
		$blackScreen.modulate.a += 0.05
		await get_tree().create_timer(0.01).timeout
	get_tree().quit()


func _on_button_focus_entered():
	$Click.play()
func _on_continue_focus_entered():
	$Click.play()
func _on_button_2_focus_entered():
	$Click.play()
func _on_button_3_focus_entered():
	$Click.play()
func _on_next_focus_entered():
	$Click.play()

func _on_button_mouse_entered():
	$Select.play()
func _on_continue_mouse_entered():
	$Select.play()
func _on_button_2_mouse_entered():
	$Select.play()
func _on_button_3_mouse_entered():
	$Select.play()
func _on_next_mouse_entered():
	$Select.play()

func _on_line_edit_text_changed(_new_text):
	$Typing.play()


func _on_button_5_pressed():
	get_tree().change_scene_to_file("res://settings.tscn")
