extends Node2D

var array1 = []
var array2 = []
var array3 = []
var startPoint = []
var room_count = 50
var room_count1
var dungeon_size_x = 50
var dungeon_size_y = 50
var count = 15
var countExpanded = 1
var penis = 3
var fff = 0
var x1 = 0
var y1 = 0

var direction
var direction_x
var direction_y

var startPosition
var newPosition

func _ready():
	x1 = 0
	y1 = 0
	randomize()
	startPoint += [Vector2i(x1, y1)]
	if Events.dungeon1_generated == false:
		buildPath()
		check_dungeon()
		SpawnEnemy()
		Events.dungeon1_generated = true
	
	Events.PlayerLoad()
	Events.player1.get_node("Outside").enabled = false
	#var player1 = load("res://Маша.tscn").instantiate()
	#
	#var ability = load("Save/AbilityData.res")
	#if not ability["Ability1"] == null:
		#player1.get_node("ui/AbilityPanel").AbilitySelected = player1.get_node(ability["Ability1"])
		#player1.get_node("ui/AbilityPanel").ability1()
	#if not ability["Ability2"] == null:
		#player1.get_node("ui/AbilityPanel").AbilitySelected = player1.get_node(ability["Ability2"])
		#player1.get_node("ui/AbilityPanel").ability2()
	#
	#var Inv = load("Save/InvPack.json")
	#var PlayerInv = player1.get_node("ui/InventoryPanel/Panel/Inventory/InventoryGrid")
	#var InvData = PlayerInv.deserialize(Inv.data)
	#
	#var Char = load("Save/СharData.res")
	#player1.strength = Char["Str"]
	#player1.agility = Char["Agi"]
	#player1.intellect = Char["Int"]
	#player1.health = Char["HP"]
	#player1.originium = Char["OR"]
	#player1.level = Char["Lvl"]
	#player1.experience = Char["Exp"]
	#player1.points = Char["Lvl_points"]
	#
	#var equip = load("Save/EquipData.res")
	#if not equip["Weapon"] == null:
		#player1.get_node("ui/InventoryPanel/Panel/Equipment/MainWeapon2").create_and_add_item(equip["Weapon"])
		#player1._on_main_weapon_item_set(player1.get_node("ui/InventoryPanel/Panel/Equipment/MainWeapon2").get_item_by_id(equip["Weapon"]))
	#if not equip["Helmet"] == null:
		#player1.get_node("ui/InventoryPanel/Panel/Equipment/Helmet2").create_and_add_item(equip["Helmet"])
		#player1._on_helmet_item_set(player1.get_node("ui/InventoryPanel/Panel/Equipment/Helmet2").get_item_by_id(equip["Helmet"]))
	#if not equip["BodyArmor"] == null:
		#player1.get_node("ui/InventoryPanel/Panel/Equipment/BodyArmor2").create_and_add_item(equip["BodyArmor"])
		#player1._on_body_armor_item_set(player1.get_node("ui/InventoryPanel/Panel/Equipment/BodyArmor2").get_item_by_id(equip["BodyArmor"]))
	#
	Events.player1.position = Vector2(0,0)
	add_child(Events.player1)
	Events.player1.set_owner(self)
	
	Events.player1.get_node("ui/blackScreen").modulate.a = 1
	
	var _blackScren = Events.player1.get_node("ui/blackScreen")
	while not _blackScren.modulate.a <= 0:
		_blackScren.modulate.a -= 0.05
		await get_tree().create_timer(0.01).timeout
	Events.can_use = true

func check_dungeon():
	room_count1 = room_count
	build_dungeon_startRoom()
	build_dungeon_endRoom()
	while count > 0:
		build_dungeon()
		count -= 1
	while countExpanded > 0:
		floorExpanded()
		countExpanded -= 1
	buildWalls()
func build_dungeon():
	startPosition = Vector2i(startPoint[randi_range(0, (startPoint.size())-1)])
	while room_count > 0:
		Direction()
		newPosition = startPosition + Vector2i(direction_x)
		#var x1 = randi_range(-dungeon_size_x, dungeon_size_x)
		#var y1 = randi_range(-dungeon_size_y, dungeon_size_y)
		array1 = [newPosition]
		if array2.has(newPosition) == false:
			#var type = randi_range(7, 8)
			$Ground.set_cell(0, Vector2i(newPosition), 1, Vector2i(0,0), 0)
			array2.append_array(array1)
			room_count -= 1
		#else:
			#print(newPosition)
		array1 = []
		startPosition = newPosition
		newPosition = null
	room_count = room_count1
func build_dungeon_startRoom():
	startPosition = Vector2i(startPoint[0])
	while room_count > 0:
		Direction()
		newPosition = startPosition + Vector2i(direction_x)
		#var x1 = randi_range(-dungeon_size_x, dungeon_size_x)
		#var y1 = randi_range(-dungeon_size_y, dungeon_size_y)
		array1 = [newPosition]
		if array2.has(newPosition) == false:
			#var type = randi_range(7, 8)
			$Ground.set_cell(0, Vector2i(newPosition), 1, Vector2i(0,0), 0)
			array2.append_array(array1)
			room_count -= 1
		#else:
			#print(newPosition)
		array1 = []
		startPosition = newPosition
		newPosition = null
	room_count = room_count1
func build_dungeon_endRoom():
	startPosition = Vector2i(startPoint[(startPoint.size())-1])
	while room_count > 0:
		Direction()
		newPosition = startPosition + Vector2i(direction_x)
		#var x1 = randi_range(-dungeon_size_x, dungeon_size_x)
		#var y1 = randi_range(-dungeon_size_y, dungeon_size_y)
		array1 = [newPosition]
		if array2.has(newPosition) == false:
			#var type = randi_range(7, 8)
			$Ground.set_cell(0, Vector2i(newPosition), 1, Vector2i(0,0), 0)
			array2.append_array(array1)
			room_count -= 1
		#else:
			#print(newPosition)
		array1 = []
		startPosition = newPosition
		newPosition = null
	room_count = room_count1

func floorExpanded():
	array3 = []
	#var negr = 0
	var negr2 = array2.size()-1
	while negr2 > -1:
		startPosition = Vector2i(array2[negr2])
		if not array2.has(Vector2i(startPosition.x + 1, startPosition.y)):
			$Ground.set_cell(0, Vector2i(startPosition.x + 1, startPosition.y), 1, Vector2i(0,0), 0)
			array3.append_array([Vector2i(startPosition.x + 1, startPosition.y)])
		
		if not array2.has(Vector2i(startPosition.x + 1, startPosition.y + 1)):
			$Ground.set_cell(0, Vector2i(startPosition.x + 1, startPosition.y + 1), 1, Vector2i(0,0), 0)
			array3.append_array([Vector2i(startPosition.x + 1, startPosition.y + 1)])
		
		if not array2.has(Vector2i(startPosition.x - 1, startPosition.y)):
			$Ground.set_cell(0, Vector2i(startPosition.x - 1, startPosition.y), 1, Vector2i(0,0), 0)
			array3.append_array([Vector2i(startPosition.x - 1, startPosition.y)])
		
		if not array2.has(Vector2i(startPosition.x - 1, startPosition.y - 1)):
			$Ground.set_cell(0, Vector2i(startPosition.x - 1, startPosition.y - 1), 1, Vector2i(0,0), 0)
			array3.append_array([Vector2i(startPosition.x - 1, startPosition.y - 1)])
		
		if not array2.has(Vector2i(startPosition.x, startPosition.y + 1)):
			$Ground.set_cell(0, Vector2i(startPosition.x, startPosition.y + 1), 1, Vector2i(0,0), 0)
			array3.append_array([Vector2i(startPosition.x, startPosition.y + 1)])
		
		if not array2.has(Vector2i(startPosition.x - 1, startPosition.y + 1)):
			$Ground.set_cell(0, Vector2i(startPosition.x - 1, startPosition.y + 1), 1, Vector2i(0,0), 0)
			array3.append_array([Vector2i(startPosition.x - 1, startPosition.y + 1)])
		
		if not array2.has(Vector2i(startPosition.x, startPosition.y - 1)):
			$Ground.set_cell(0, Vector2i(startPosition.x, startPosition.y - 1), 1, Vector2i(0,0), 0)
			array3.append_array([Vector2i(startPosition.x, startPosition.y - 1)])
		
		if not array2.has(Vector2i(startPosition.x + 1, startPosition.y - 1)):
			$Ground.set_cell(0, Vector2i(startPosition.x + 1, startPosition.y - 1), 1, Vector2i(0,0), 0)
			array3.append_array([Vector2i(startPosition.x + 1, startPosition.y - 1)])
		negr2 -= 1
	array2.append_array(array3)

func buildWalls():
	var tileCount = int(array2.size())
	var tileNow = array2[0]
	var _abobus = 0
	while tileCount > 1:
		# Горизонатльные/Вертикальные стены #
		if array2.has(Vector2i(tileNow.x+1, tileNow.y)) == false:
			$Walls.set_cell(1, Vector2i(tileNow.x+1, tileNow.y), 8, Vector2i(0,0), 0)
		if array2.has(Vector2i(tileNow.x-1, tileNow.y)) == false:
			$Walls.set_cell(1, Vector2i(tileNow.x-1, tileNow.y), 8, Vector2i(0,0), 0)
		if array2.has(Vector2i(tileNow.x, tileNow.y+1)) == false:
			$Walls.set_cell(1, Vector2i(tileNow.x, tileNow.y+1), 8, Vector2i(0,0), 0)
		if array2.has(Vector2i(tileNow.x, tileNow.y-1)) == false:
			$Walls.set_cell(1, Vector2i(tileNow.x, tileNow.y-1), 8, Vector2i(0,0), 0)
		
		# Диагональные стены #
		if array2.has(Vector2i(tileNow.x+1, tileNow.y+1)) == false:
			$Walls.set_cell(1, Vector2i(tileNow.x+1, tileNow.y+1), 8, Vector2i(0,0), 0)
		if array2.has(Vector2i(tileNow.x-1, tileNow.y-1)) == false:
			$Walls.set_cell(1, Vector2i(tileNow.x-1, tileNow.y-1), 8, Vector2i(0,0), 0)
		if array2.has(Vector2i(tileNow.x-1, tileNow.y+1)) == false:
			$Walls.set_cell(1, Vector2i(tileNow.x-1, tileNow.y+1), 8, Vector2i(0,0), 0)
		if array2.has(Vector2i(tileNow.x+1, tileNow.y-1)) == false:
			$Walls.set_cell(1, Vector2i(tileNow.x+1, tileNow.y-1), 8, Vector2i(0,0), 0)
			
		_abobus += 1
		tileCount -= 1
		tileNow = array2[tileCount]
		#print(tileNow)
	#pass
func buildPath():
	var govno = 10 #randi_range(5,8)
	startPosition = Vector2i(startPoint[randi_range(0, (startPoint.size())-1)])
	Direction()
	while govno > 0:
		penis = 3
		while penis > 0:
			var count1 = randi_range(10, 20)
			while count1 > 0:
				newPosition = startPosition + Vector2i(direction_x)
				array1 = [newPosition]
				$Ground.set_cell(0, Vector2i(newPosition), 1, Vector2i(0,0), 0)
				array2.append_array(array1)
				startPoint.append_array(array1)
				count1 -= 1
				array1 = []
				startPosition = newPosition
				newPosition = null
			#print(array2.size())
			startPosition = Vector2i(array2[array2.size()-1])
			if direction_x == Vector2i(1,0):
				direction = randi_range(1, 3)
				if direction == 1:
					direction_x = Vector2i(0,1)
				elif direction == 2:
					direction_x = Vector2i(0,-1)
				elif direction == 3:
					direction_x = Vector2i(1,0)
			elif direction_x == Vector2i(0,1):
				direction = randi_range(1, 3)
				if direction == 1:
					direction_x = Vector2i(1,0)
				elif direction == 2:
					direction_x = Vector2i(-1,0)
				elif direction == 3:
					direction_x = Vector2i(0,1)
			elif direction_x == Vector2i(-1,0):
				direction = randi_range(1, 3)
				if direction == 1:
					direction_x = Vector2i(0,1)
				elif direction == 2:
					direction_x = Vector2i(0,-1)
				elif direction == 3:
					direction_x = Vector2i(-1,0)
			elif direction_x == Vector2i(0,-1):
				direction = randi_range(1, 3)
				if direction == 1:
					direction_x = Vector2i(1,0)
				elif direction == 2:
					direction_x = Vector2i(-1,0)
				elif direction == 3:
					direction_x = Vector2i(0,-1)
			penis -= 1
		govno -= 1

func SpawnEnemy():
	randomize()
	var Enemy_count = 20
	#var Enemy_Spawn = startPoint
	while Enemy_count > 0:
		var Enemy = load("res://EnemyTest.tscn").instantiate()
		var EnemySpawn = randi_range(10, startPoint.size()-1)
		Enemy.position = Vector2i($Ground.map_to_local(startPoint[EnemySpawn]).x * 0.2, $Ground.map_to_local(startPoint[EnemySpawn]).y * 0.2)
		#print(startPoint[10])
		#print(Enemy.position)
		add_child(Enemy)
		Enemy.set_owner(self)
		array2.erase(Enemy.position)
		Enemy_count -= 1
	

func Direction():
	randomize()
	direction = randi_range(1, 4)
	if direction == 1: #1
		direction_x = Vector2i(1,0)
		#direction_y = 0
	elif direction == 2: #2
		direction_x = Vector2i(0,-1)
		#direction_y = 1
	elif direction == 3: #3
		direction_x = Vector2i(-1,0)
		#direction_y = 0
	elif direction == 4: #4
		direction_x = Vector2i(0,1)
		#direction_y = -1
	#direction_x = randi_range(-1, 1)
	#direction_y = randi_range(-1, 1)
