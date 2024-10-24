extends Node

signal make_damage_player(value)
signal make_damage_enemy(value)
signal health_changed(bool)

signal open_chest(bool)
signal item_pickup(string)

signal change_weapon(string)
signal change_bodyarmor(string)
signal change_helmet(string)
signal change_gear(string)

var shit_happen = "true"
var quest_test_accepted = false

#var spawn = preload("res://1.tscn")

var spawn_generated = true
var dungeon1_generated = false
var dungeon1_generating = false
var map_changing = false
var character_update = false

var can_use = false
var new_save = true
var playerName = null
var dialogImage = ""

var activeSave = "Save0"
var activeSaveReturn = "Save0"
var player1
var inShop = false
var inChest = false
var chest_inv = null
var chest_items = {}
var openning_chest = false

var lang = "ru"

func _ready():
	if FileAccess.file_exists("user://settings.ini"):
		print("Загрузка настроек...")
		var langsave = ConfigFile.new()
		langsave.load("user://settings.ini")
		lang = langsave.get_value("lang", "lang")
		print(lang)
	#else:
	#	var new_settings = ConfigFile.new()
	#	new_settings.set_value("lang", "lang", "ru")
	#	new_settings.save("user://settings.ini")
	
	if FileAccess.file_exists("user://audioSettings.json"):
		print("Загрузка настроек музыки...")
		var audioDB = load("user://audioSettings.json")
		AudioServer.set_bus_volume_db(0, audioDB.data[0])
		AudioServer.set_bus_volume_db(2, audioDB.data[1])
		AudioServer.set_bus_volume_db(3, audioDB.data[2])
		AudioServer.set_bus_volume_db(1, audioDB.data[3])
	
	TranslationServer.set_locale(lang)
	update()

func lang_update(id):
	match id:
		0:
			lang = "ru"
		1:
			lang = "en"
	update()

func update():
	TranslationServer.set_locale(lang)
	print("Активный язык: ", lang)
	print(" ")
	#get_tree().get_first_node_in_group("scene")
	#get_tree().reload_current_scene()
	print("	✔Загрузка завершена✔")
	print(" ")

func PlayerSave(player):
	DirAccess.make_dir_absolute("user://Save/")
	DirAccess.make_dir_absolute("user://Save/"+activeSave)
	#print(DirAccess.get_directories_at("user://"))
	#var amogus = DirAccess.get_directories_at("user://")
	#print(amogus)
	
	var ability1; var ability2
	if not player[0].get_node("ui/AbilityPanel").AbilityActive1 == null:
		ability1 = "ui/AbilityPanel/Panel/" + player[0].get_node("ui/AbilityPanel").AbilityActive1.type + "/" + player[0].get_node("ui/AbilityPanel").AbilityActive1.id
	if not player[0].get_node("ui/AbilityPanel").AbilityActive2 == null:
		ability2 = "ui/AbilityPanel/Panel/" + player[0].get_node("ui/AbilityPanel").AbilityActive2.type + "/" + player[0].get_node("ui/AbilityPanel").AbilityActive2.id
	var Ability = {"Ability1" : ability1, "Ability2" : ability2, "UnlockerAbility" : player[0].unlockedAbilitys}
	print("Ability", Ability)
	var AbilityData = PackedDataContainer.new()
	AbilityData.pack(Ability)
	ResourceSaver.save(AbilityData, "user://Save/"+activeSave+"/AbilityData.res")
	
	var InvData = player[0].get_node("ui/InventoryPanel/Panel/Inventory/InventoryGrid").serialize()
	var InvPack = JSON.new()
	InvPack.set_data(InvData)
	ResourceSaver.save(InvPack, "user://Save/"+activeSave+"/InvPack.json")
	
	#get_item_at(Vector2i(0,0)).get_property("id")
	var mainWeapon
	var Helmet
	var Body
	var Gear
	if not player[0].get_node("ui/InventoryPanel/Panel/Equipment/MainWeapon2").get_item_at(Vector2i(0,0)) == null:
		mainWeapon = player[0].get_node("ui/InventoryPanel/Panel/Equipment/MainWeapon2").get_item_at(Vector2i(0,0)).get_property("id")
	if not player[0].get_node("ui/InventoryPanel/Panel/Equipment/Helmet2").get_item_at(Vector2i(0,0)) == null:
		Helmet = player[0].get_node("ui/InventoryPanel/Panel/Equipment/Helmet2").get_item_at(Vector2i(0,0)).get_property("id")
	if not player[0].get_node("ui/InventoryPanel/Panel/Equipment/BodyArmor2").get_item_at(Vector2i(0,0)) == null:
		Body = player[0].get_node("ui/InventoryPanel/Panel/Equipment/BodyArmor2").get_item_at(Vector2i(0,0)).get_property("id")
	if not player[0].get_node("ui/InventoryPanel/Panel/Equipment/Gear2").get_item_at(Vector2i(0,0)) == null:
		Gear = player[0].get_node("ui/InventoryPanel/Panel/Equipment/Gear2").get_item_at(Vector2i(0,0)).get_property("id")
	var EquipItems = {"Weapon":mainWeapon, "Helmet":Helmet, "BodyArmor":Body, "Gear":Gear}
	var EquipData = PackedDataContainer.new()
	EquipData.pack(EquipItems)
	ResourceSaver.save(EquipData, "user://Save/"+activeSave+"/EquipData.res")
	
	var _char = {
				"SaveName":player[0].PlayerName,
				"Str":player[0].strength,
				"Agi":player[0].agility,
				"Int":player[0].intellect,
				"HP":player[0].health,
				"OR":player[0].originium,
				"Lvl":player[0].level,
				"Exp":player[0].experience,
				"Lvl_points":player[0].points,
				"Chervonets":player[0].money
				}
	var charData = PackedDataContainer.new()
	charData.pack(_char)
	ResourceSaver.save(charData, "user://Save/"+activeSave+"/СharData.res")
	
	var questNames
	var questProgress
	var dict = {}
	var num = 1
	var quest = get_tree().get_first_node_in_group("quest_place").get_children()
	for a in quest:
		questNames = a.Panelname
		questProgress = a.questCountStart
		var aaooaa = {"Name"+str(num):questNames, "Progress"+str(num):questProgress}
		dict.merge(aaooaa)
		num += 1
	#quests.append(questNames)
	#quests.append(questProgress)
	print(dict)
	var QuestData = PackedDataContainer.new()
	QuestData.pack(dict)
	ResourceSaver.save(QuestData, "user://Save/"+activeSave+"/QuestData.res")
	
	var ChestData = player[0].get_node("ui/Chest/ChestInventory/ChestGrid").serialize()
	#print(ChestData)
	var ChestPack = JSON.new()
	ChestPack.set_data(ChestData)
	ResourceSaver.save(ChestPack, "user://Save/"+activeSave+"/PerChest.json")
	
	activeSave = activeSaveReturn
func PlayerLoad():
	player1 = load("res://Маша.tscn").instantiate()
	
	var ChestData = load("user://Save/"+activeSave+"/PerChest.json")
	var ChestInv = player1.get_node("ui/Chest/ChestInventory/ChestGrid")
	ChestInv.deserialize(ChestData.data)
	
	var quests = load("user://Save/"+activeSave+"/QuestData.res")
	var num = 1
	for quest in quests:
		if quest == "Name"+str(num):
			var aaooaa = load("res://Quests/"+str(quests["Name"+str(num)])+".tscn").instantiate()
			player1.get_node("ui/QuestPanel/Panel/VBoxContainer").add_child(aaooaa)
			print("aaooaa до:", aaooaa.questCountStart)
			aaooaa.questCountStart = quests["Progress"+str(num)]
			print("aaooaa после:", aaooaa.questCountStart)
			num += 1
	
	var ability = load("user://Save/"+activeSave+"/AbilityData.res")
	if not ability["Ability1"] == null:
		player1.get_node("ui/AbilityPanel").AbilitySelected = player1.get_node(ability["Ability1"])
		player1.get_node("ui/AbilityPanel").ability1()
	if not ability["Ability2"] == null:
		player1.get_node("ui/AbilityPanel").AbilitySelected = player1.get_node(ability["Ability2"])
		player1.get_node("ui/AbilityPanel").ability2()
	for i in ability["UnlockerAbility"]:
		player1.get_node(str("ui/AbilityPanel/", i,"/LevelLock")).unlock()
	
	var Inv = load("user://Save/"+activeSave+"/InvPack.json")
	var PlayerInv = player1.get_node("ui/InventoryPanel/Panel/Inventory/InventoryGrid")
	PlayerInv.deserialize(Inv.data)
	
	var Char = load("user://Save/"+activeSave+"/СharData.res")
	player1.PlayerName = Char["SaveName"]
	player1.strength = Char["Str"]
	player1.agility = Char["Agi"]
	player1.intellect = Char["Int"]
	player1.health = Char["HP"]
	player1.originium = Char["OR"]
	player1.level = Char["Lvl"]
	player1.experience = Char["Exp"]
	player1.points = Char["Lvl_points"]
	player1.money = Char["Chervonets"]
	
	var equip = load("user://Save/"+activeSave+"/EquipData.res")
	if not equip["Weapon"] == null:
		player1.get_node("ui/InventoryPanel/Panel/Equipment/MainWeapon2").create_and_add_item(equip["Weapon"])
		#player1._on_main_weapon_item_set(player1.get_node("ui/InventoryPanel/Panel/Equipment/MainWeapon2").get_item_by_id(equip["Weapon"]))
	if not equip["Helmet"] == null:
		player1.get_node("ui/InventoryPanel/Panel/Equipment/Helmet2").create_and_add_item(equip["Helmet"])
		#player1._on_helmet_item_set(player1.get_node("ui/InventoryPanel/Panel/Equipment/Helmet2").get_item_by_id(equip["Helmet"]))
	if not equip["BodyArmor"] == null:
		player1.get_node("ui/InventoryPanel/Panel/Equipment/BodyArmor2").create_and_add_item(equip["BodyArmor"])
		#player1._on_body_armor_item_set(player1.get_node("ui/InventoryPanel/Panel/Equipment/BodyArmor2").get_item_by_id(equip["BodyArmor"]))
	if not equip["Gear"] == null:
		player1.get_node("ui/InventoryPanel/Panel/Equipment/Gear2").create_and_add_item(equip["Gear"])
	activeSave = activeSaveReturn

func openShop():
	get_tree().get_first_node_in_group("player").ShopFunc()
func openChest():
	get_tree().get_first_node_in_group("player").ChestFunc()
func dialogOver():
	get_tree().get_first_node_in_group("player").dialogOver()

func QuestAccept(quest):
	var quest1 = load(quest).instantiate()
	get_tree().get_first_node_in_group("quest_place").add_child(quest1)

func EnemyDeath(EnemyType, player):
	if EnemyType == "Enemy":
		player.experience += 20
		player.money += 10
		player._update()
		print(player, " kill ", EnemyType, " for 10 exp")
		if player.has_node("ui/QuestPanel/Panel/VBoxContainer/QuestTest"):
			player.get_node("ui/QuestPanel/Panel/VBoxContainer/QuestTest").QuestProgress()
		#if get_tree().get_first_node_in_group("quest_test"):
			#get_tree().get_first_node_in_group("quest_test").QuestProgress()
