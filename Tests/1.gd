extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	if Events.new_save == true:
		if FileAccess.file_exists("user://Save/"+Events.activeSave+"/PerChest.json") == true:
			DirAccess.remove_absolute("user://Save/"+Events.activeSave+"/PerChest.json")
		var player = load("res://Маша.tscn")
		var player1 = player.instantiate()
		player1.get_node("ui/blackScreen").modulate.a = 1
		player1.get_node("Outside").enabled = true
		player1.position = Vector2(500,200)
		player1.PlayerName = Events.playerName
		player1.get_node("ui/InventoryPanel/Panel/Equipment/MainWeapon2").create_and_add_item("Weapon1")
		#player1._on_main_weapon_item_set(player1.get_node("ui/InventoryPanel/Panel/Equipment/MainWeapon2").get_item_by_id("Weapon1"))
		add_child(player1)
		player1.set_owner(self)
		player1.health = player1.max_health
		player1.originium = player1.max_originium
		var player2 = [player1]
		Events.PlayerSave(player2)
		Events.new_save = false
		var _blackScren = player1.get_node("ui/blackScreen")
		while not _blackScren.modulate.a <= 0:
			_blackScren.modulate.a -= 0.05
			await get_tree().create_timer(0.01).timeout
	else:
		Events.PlayerLoad()
		Events.player1.get_node("ui/blackScreen").modulate.a = 1
		Events.player1.get_node("Outside").enabled = true
		Events.player1.position = Vector2($DungeonTest.position)
		add_child(Events.player1)
		Events.player1.set_owner(self)
		var _blackScren = Events.player1.get_node("ui/blackScreen")
		while not _blackScren.modulate.a <= 0:
			_blackScren.modulate.a -= 0.05
			await get_tree().create_timer(0.01).timeout
	Events.can_use = true


#func _on_audio_stream_player_finished():
	#$AudioStreamPlayer.playing = true
