extends CharacterBody2D

var strength = 1
var agility = 1
var intellect = 1
var damage = strength*2
var max_health = 100
var health = 100
var originium = 100
var max_originium = 100
var speed = 120
var speed_action = 1
var PDef = 0
var MDef = 0
var points = 0
var experience = 0
var level = 1

var damage_armor = 0
var PDef_armor = 0
var MDef_armor = 0
var strength_armor = 0
var agility_armor = 0
var intellect_armor = 0
var max_health_armor = 0
var max_originium_armor = 0

var damage_weapon = 0
var PDef_weapon = 0
var MDef_weapon = 0
var strength_weapon = 0
var agility_weapon = 0
var intellect_weapon = 0
var max_health_weapon = 0
var max_originium_weapon = 0

var damage_helmet = 0
var PDef_helmet = 0
var MDef_helmet = 0
var strength_helmet = 0
var agility_helmet = 0
var intellect_helmet = 0
var max_health_helmet = 0
var max_originium_helmet = 0

var damage_gear = 0
var PDef_gear = 0
var MDef_gear = 0
var strength_gear = 0
var agility_gear = 0
var intellect_gear = 0
var max_health_gear = 0
var max_originium_gear = 0

var player
@onready var MainWeapon = get_node("ui/InventoryPanel/Panel/Equipment/MainWeapon")
@onready var BodyArmor = get_node("ui/InventoryPanel/Panel/Equipment/BodyArmor")
@onready var Helmet = get_node("ui/InventoryPanel/Panel/Equipment/Helmet")
@onready var Gear = get_node("ui/InventoryPanel/Panel/Equipment/Gear")
@onready var HP_regen_Timer = get_node("HP_regen_base")
@onready var HP_regen_active = get_node("HP_regen_base/HP_regen_active")
@onready var actionable_finder = $Action
var type
var DClick
var MainWeapon_item = null
var BodyArmor_item = null
var Helmet_item = null
var Gear_item = null
var MainWeapon_old_item = null
var BodyArmor_old_item = null
var Helmet_old_item = null
var Gear_old_item = null
var chest_inventory1 = null
var chest_inventory2 = null

var talking = false
var in_dialog_distance = false
var idle = true 
var ability2 = false
var has_weapon = false
var walking = true
var running = false
var still_attack = false
var in_distance = false
var can_experienced = true
var was_damaged = false
var in_drop_zone = false
var in_gui = false

var ability1 = false
var dash_speed_x = 500
var dash_speed_y = 400
var direction = position
var mouse_local
var PlayerName = "Test"

var turn_right = true
var turn_left = false
var turn_up = false
var turn_down = true

var unlockedAbilitys = []
var money = 0
var BuyingSelling = false
var loadingCharacter = true

@onready var sword = get_node("Body/Кисть21/Кисть22/Меч")

@export var sfx_walk = AudioStream
@export var sfx_attack = AudioStream

func _ready():
	if not $ui/InventoryPanel/Panel/Equipment/MainWeapon2.get_item_at(Vector2i(0,0)) == null:
		MainWeapon.equipped_item = 0
	if not $ui/InventoryPanel/Panel/Equipment/Helmet2.get_item_at(Vector2i(0,0)) == null:
		Helmet.equipped_item = 0
	if not $ui/InventoryPanel/Panel/Equipment/BodyArmor2.get_item_at(Vector2i(0,0)) == null:
		BodyArmor.equipped_item = 0
	if not $ui/InventoryPanel/Panel/Equipment/Gear2.get_item_at(Vector2i(0,0)) == null:
		Gear.equipped_item = 0
	
	$sfx.stream = sfx_walk
	player = get_tree()
	$ui/CharacterPanel/Panel/UpAttribute/Name.text = PlayerName
	$ui/InventoryPanel/Panel/Inventory/Money.text = str(money)
	$ui/Hud/BarHealth.visible = true
	$ui/Hud/BarOrig.visible = true
	#$ui/PlayerButtons.visible = true
	$ActionLabel.visible = false
	_update()
	Events.connect("make_damage_enemy", health_update)
	DialogueManager.connect("dialogue_ended", dialog)
	loadingCharacter = false
func _process(_delta):
	$ui/Hud/BarHealth/HealthLabel.text = str(health, "/", max_health)
	$ui/Hud/BarOrig/OrigLabel.text = str(originium, "/", max_originium)
	$ui/Hud/BarHealth.max_value = max_health
	$ui/Hud/BarOrig.max_value = max_originium
	$ui/Hud/BarHealth.value = health
	$ui/Hud/BarOrig.value = originium
	
	if Input.is_action_just_pressed("hud_character"):
		_on_character_pressed()
	if Input.is_action_just_pressed("hud_abilitys"):
		_on_ability_pressed()
	if Input.is_action_just_pressed("hud_inventory"):
		_on_inventory_pressed()
	if Input.is_action_just_pressed("hud_quests"):
		_on_quest_pressed()
	
	$ui/Hud/Exp.value = experience
	
	if Input.is_action_just_pressed("ui_esc"):
		$ui/CharacterPanel.visible = false
		$ui/QuestPanel.visible = false
		$ui/InventoryPanel.visible = false
		$ui/AbilityPanel.visible = false
		$ui/Menu.visible = true
		get_tree().paused = true
	#if Input.is_action_just_pressed("test_2"):
		#ShopFunc()
	
	characteristics(_delta)
	#print(HP_regen_Timer.time_left)
	health_regen()
func characteristics(_delta):
	if level == 20:
		can_experienced = false
	
	## УВАГА! УБРАТЬ ПОТОМ! УВАГА! №
	if Input.is_action_just_pressed("test_experience") and can_experienced == true:
		experience += 40
	## УВАГА! УБРАТЬ ПОТОМ! УВАГА! №
	
	if experience == 100 and can_experienced == true:
		level += 1
		points += 3
		experience = 0
		_update()
	if experience >= 101 and can_experienced == true:
		level += 1
		points += 3
		experience -= 100
		_update()
	
	if points >= 1:
		$ui/CharacterPanel/Panel/DownAttribute/button_str.disabled = false
		$ui/CharacterPanel/Panel/DownAttribute/button_agi.disabled = false
		$ui/CharacterPanel/Panel/DownAttribute/button_int.disabled = false
	if points == 0:
		$ui/CharacterPanel/Panel/DownAttribute/button_str.disabled = true
		$ui/CharacterPanel/Panel/DownAttribute/button_agi.disabled = true
		$ui/CharacterPanel/Panel/DownAttribute/button_int.disabled = true

func _update():
	damage = 0+(strength*2)+damage_weapon+damage_armor+damage_helmet
	max_health = 100+(strength*10)+max_health_weapon+max_health_armor+max_health_helmet
	
	max_originium = 100+(intellect*5)+max_originium_helmet+max_originium_weapon+max_originium_armor
	
	@warning_ignore("integer_division")
	speed_action = 1+((agility/5)/10)
	speed = 120+(agility)
	
	if health > max_health:
		health = max_health
	
	if originium > max_originium:
		originium = max_originium
	#print("Здоровье: ", max_health)
	#print("Мана: ", max_originium)
	
	$ui/Hud/Label4.text = str(PlayerName)
	$ui/Hud/Label6.text = str(experience)
	$ui/Hud/Exp.value = experience
	$ui/Hud/Label2.text = str(level)
	$ui/InventoryPanel/Panel/Inventory/Money.text = str(money)
	
	$ui/CharacterPanel/Panel/DownAttribute/str.text = str(strength)
	$ui/CharacterPanel/Panel/DownAttribute/agi.text = str(agility)
	$ui/CharacterPanel/Panel/DownAttribute/int.text = str(intellect)
	$ui/CharacterPanel/Panel/DownAttribute/hp.text = str(max_health)
	$ui/CharacterPanel/Panel/DownAttribute/atk.text = str(damage)
	$ui/CharacterPanel/Panel/DownAttribute/pdef.text = str(PDef)
	$ui/CharacterPanel/Panel/DownAttribute/mdef.text = str(MDef)
	$ui/CharacterPanel/Panel/DownAttribute/mana.text = str(max_originium)
	
	$ui/CharacterPanel/Panel/UpAttribute/Lvl_num.text = str(level)
	$ui/CharacterPanel/Panel/UpAttribute/Lvl.value = experience
	
	$ui/CharacterPanel/Panel/DownAttribute/Str_Bar.value = strength
	$ui/CharacterPanel/Panel/DownAttribute/Agi_Bar.value = agility
	$ui/CharacterPanel/Panel/DownAttribute/Int_Bar.value = intellect
	@warning_ignore("integer_division")
	$ui/CharacterPanel/Panel/DownAttribute/HP_Bar.value = max_health/10
	@warning_ignore("integer_division")
	$ui/CharacterPanel/Panel/DownAttribute/Atk_Bar.value = damage/2
	$ui/CharacterPanel/Panel/DownAttribute/PDef_Bar.value = PDef
	$ui/CharacterPanel/Panel/DownAttribute/MDef_Bar.value = MDef
	@warning_ignore("integer_division")
	$ui/CharacterPanel/Panel/DownAttribute/Mana_Bar.value = max_originium/10

func _on_hurtbox_area_entered(area):
	if area.owner.is_in_group("Enemy"):
		area.add_to_group("can_be_damaged")
		area.get_parent().can_be_damaged()
	in_distance = true
func _on_hurtbox_area_exited(area):
	if area.owner != null:
		if area.owner.is_in_group("Enemy"):
			area.remove_from_group("can_be_damaged")
			area.get_parent().can_be_damaged()
		in_distance = false
func _on_action_area_entered(_area):
	in_dialog_distance = true
	$ActionLabel.visible = true
func _on_action_area_exited(_area):
	in_dialog_distance = false
	$ActionLabel.visible = false

func _input(event):
	if event is InputEventMouseButton:
		DClick = event.double_click
func _unhandled_input(_event: InputEvent) -> void:
	if Events.can_use == true and Input.is_action_just_pressed("use") and in_dialog_distance == true:
		var actionable = actionable_finder.get_overlapping_areas()
		if actionable.size() > 0:
			$AnimationPlayer.current_animation = "idle1"
			$AnimationPlayer.speed_scale = 0.5
			if actionable[0].type == "dialog" or actionable[0].type == "area":
				ability1 = true
				ability2 = true
				walking = false
				talking = true
				$ui/Hud.visible = false
				$ui/CharacterPanel.visible = false
				$ui/InventoryPanel.visible = false
				$ui/AbilityPanel.visible = false
				$ui/PlayerButtons.visible = false
				$ui/QuestPanel.visible = false
				#$ui/BarOrig.visible = false
				#$ui/BarHealth.visible = false
				actionable[0].action()
			elif actionable[0].type == "chest":
				actionable[0].action()
func dialog(_kek):
	walking = true
	talking = false
	ability1 = false
	ability2 = false
	#if Events.inShop == false and $ui/Hud.visible == false:
		#$ui/Hud.visible = true

func health_update(enemy_damage):
	print("? Проверка на пидора: ", get_tree())
	if not get_tree() == null:
		$takingDamage.play()
		print("- Пидорас не найден")
		health -= enemy_damage - (PDef)
		print("Нанесён урон: ", enemy_damage - (PDef))
		if health <= 0:
			#print(get_tree())
			#$Hitbox/CollisionShape2D.disabled = true
			print("Игрок умер")
			Death()
		else:
			#print(health)
			#----------- ВРЕМЕННО! УБЕРИ ПОТОМ! -----------#
			$Body.use_parent_material = false
			await player.create_timer(0.2).timeout
			$Body.use_parent_material = true
			#----------- ВРЕМЕННО! УБЕРИ ПОТОМ! -----------#
			HP_regen_Timer.start()
			health_regen()
	else:
		print("+ Пидорас найден!")
		queue_free()
func health_regen():
	if HP_regen_Timer.time_left == 0:
		while health < max_health:
			if HP_regen_active.time_left == 0:
				health += 1
				HP_regen_active.start()
			else:
				return

func _physics_process(_delta):
	if walking == true and Events.inShop == false and Events.inChest == false:
		velocity = Vector2.ZERO
		if Input.is_action_pressed("ui_right") and not Input.is_action_pressed("ui_left"):
			velocity.x += 1.0
			turn_character_x()
			turn_right = true
			turn_left = false
		if Input.is_action_pressed("ui_left") and not Input.is_action_pressed("ui_right"):
			velocity.x -= 1.0
			turn_character_x()
			turn_right = false
			turn_left = true
		if Input.is_action_pressed("ui_up") and not Input.is_action_pressed("ui_down"):
			velocity.y -= 0.8
		if Input.is_action_pressed("ui_down") and not Input.is_action_pressed("ui_up"):
			velocity.y += 0.8
		if Input.is_action_pressed("ui_run"):
			speed = (120+(agility))*2
		elif not Input.is_action_pressed("ui_run"):
			speed = 120+(agility)
		set_velocity(velocity * speed)
		move_and_slide()
		
		if velocity.x == 0 and velocity.y == 0:
			$AnimationPlayer.current_animation = "idle1"
			$AnimationPlayer.speed_scale = 0.5
		elif Input.is_action_pressed("ui_right"):
			if Input.is_action_pressed("ui_run"):
				$AnimationPlayer.current_animation = "Run1"
				$AnimationPlayer.speed_scale = 1.5*speed_action
			else:
				$AnimationPlayer.current_animation = "Walk1"
				$AnimationPlayer.speed_scale = 1.0*speed_action
		elif Input.is_action_pressed("ui_left"):
			if Input.is_action_pressed("ui_run"):
				$AnimationPlayer.current_animation = "Run1"
				$AnimationPlayer.speed_scale = 1.5*speed_action
			else:
				$AnimationPlayer.current_animation = "Walk1"
				$AnimationPlayer.speed_scale = 1.0*speed_action
		elif Input.is_action_pressed("ui_up"):
			if Input.is_action_pressed("ui_run"):
				$AnimationPlayer.current_animation = "Run1"
				$AnimationPlayer.speed_scale = 1.5*speed_action
			else:
				$AnimationPlayer.current_animation = "Walk1"
				$AnimationPlayer.speed_scale = 1.0*speed_action
		elif Input.is_action_pressed("ui_down"):
			if Input.is_action_pressed("ui_run"):
				$AnimationPlayer.current_animation = "Run1"
				$AnimationPlayer.speed_scale = 1.5*speed_action
			else:
				$AnimationPlayer.current_animation = "Walk1"
				$AnimationPlayer.speed_scale = 1.0*speed_action
	if Input.is_action_pressed("ability1") and ability1 == false and ability2 == false and Events.inShop == false and Events.inChest == false:
		if not $ui/AbilityPanel.AbilityActive1 == null:
			ability1 = true
			walking = false
			if $ui/AbilityPanel.AbilityActive1.can_activate == true:
				$ui/Hud/TextureRect/Ability1/TextureProgressBar.max_value = 10*($ui/AbilityPanel.AbilityActive1.TimeActive/speed_action)
				$ui/Hud/TextureRect/Ability1/TextureProgressBar.value = 10*($ui/AbilityPanel.AbilityActive1.TimeActive/speed_action)
				#print($ui/Hud/TextureRect/Ability1/TextureProgressBar.value)
				$ui/Hud/TextureRect/Ability1/TextureProgressBar.visible = true
				$ui/AbilityPanel.AbilityActive1.AbilityUse(self)
				while not $ui/Hud/TextureRect/Ability1/TextureProgressBar.value == 0:
					$ui/Hud/TextureRect/Ability1/TextureProgressBar.value -= 1
					await get_tree().create_timer(0.09).timeout
					#print($ui/Hud/TextureRect/Ability1/TextureProgressBar.value)
			$ui/Hud/TextureRect/Ability1/TextureProgressBar.visible = false
			ability1 = false
			walking = true
	if Input.is_action_pressed("ability2") and ability2 == false and ability1 == false and Events.inShop == false and Events.inChest == false:
		if not $ui/AbilityPanel.AbilityActive2 == null:
			walking = false
			ability2 = true
			if $ui/AbilityPanel.AbilityActive2.can_activate == true:
				$ui/Hud/TextureRect/Ability2/TextureProgressBar.max_value = 10*($ui/AbilityPanel.AbilityActive2.TimeActive/speed_action)
				$ui/Hud/TextureRect/Ability2/TextureProgressBar.value = 10*($ui/AbilityPanel.AbilityActive2.TimeActive/speed_action)
				#print($ui/Hud/TextureRect/Ability1/TextureProgressBar.value)
				$ui/Hud/TextureRect/Ability2/TextureProgressBar.visible = true
				$ui/AbilityPanel.AbilityActive2.AbilityUse(self)
				while not $ui/Hud/TextureRect/Ability2/TextureProgressBar.value == 0:
					$ui/Hud/TextureRect/Ability2/TextureProgressBar.value -= 1
					await get_tree().create_timer(0.09).timeout
					#print($ui/Hud/TextureRect/Ability1/TextureProgressBar.value)
			$ui/Hud/TextureRect/Ability2/TextureProgressBar.visible = false
			walking = true
			ability2 = false
	if talking == false and Events.inShop == false and Events.inChest == false:
		mouse_local = get_global_mouse_position().angle_to_point(position)
		$Hurtbox.rotation = mouse_local
		$Action.rotation = mouse_local
	if Input.is_action_just_pressed("drop_item") and not $ui/InventoryPanel/Panel/Inventory/CtrlInventoryGridEx.get_selected_inventory_item() == null:
		var item_drop1 = preload("res://Inventory/ProtoItems/dropped_item.tscn")
		var item_drop = item_drop1.instantiate()
		get_parent().add_child(item_drop)
		$ui/InventoryPanel/Panel/Inventory/InventoryGrid.transfer_to($ui/InventoryPanel/Panel/Inventory/CtrlInventoryGridEx.get_selected_inventory_item(), item_drop.get_node("InventoryGrid"), Vector2i(0,0))
		item_drop.apply_text()
		item_drop.position = global_position
func turn_character_x():
	#print("turn_left - ", turn_left)
	#print("Turn_right - ", turn_right)
	if walking == true:
		if velocity.x > 0 and turn_right == false:
			#$Body.scale.x = 0.2
			for turn_right1 in 10:
				if $Body.scale.x < 0.9:
					$Body.scale.x = $Body.scale.x + 0.2
					await get_tree().create_timer(0.001).timeout
					continue
				if $Body.scale.x == 1.0:
					break
		if velocity.x < 0 and turn_left == false:
			#$Body.scale.x = -0.2
			for turn_left1 in 10:
				if $Body.scale.x > -0.9:
					$Body.scale.x = $Body.scale.x + -0.2
					await get_tree().create_timer(0.001).timeout
					continue
				if $Body.scale.x == -1.0:
					break
	if Input.is_action_pressed("ability1") or Input.is_action_pressed("ability2"):
		print("")
		print("	⟳ Проверка способностей...")
		print("➔ ability1: ", ability1)
		print("➔ ability2: ", ability2)
		print("➔ in_gui: ", in_gui)
		if ability1 == true and in_gui == false or ability2 == true and in_gui == false:
			print("	✔Поворот в сторону мыши активен!✔")
			if (mouse_local > 1.5 or mouse_local < -1.5):
				#$Body.scale.x = -1
				turn_right = true
				turn_left = false
			else:
				#$Body.scale.x = 1
				turn_right = false
				turn_left = true
			if turn_right == true:
				#$Body.scale.x = 0.2
				for turn_right1 in 10:
					if $Body.scale.x < 0.9:
						$Body.scale.x = $Body.scale.x + 0.2
						await get_tree().create_timer(0.001).timeout
						continue
					if $Body.scale.x == 1.0:
						break
			elif turn_left == true:
				#$Body.scale.x = -0.2
				for turn_left1 in 10:
					if $Body.scale.x > -0.9:
						$Body.scale.x = $Body.scale.x + -0.2
						await get_tree().create_timer(0.001).timeout
						continue
					if $Body.scale.x == -1.0:
						break
		else:
			print("	◬ Что-то пошло не так! ◬")
func Death():
	player.paused = true
	var nigger = load("res://DeathPanel.tscn").instantiate()
	$ui.add_child(nigger)



func _on_character_pressed():
	$Click.play()
	if $ui/CharacterPanel.visible == false:
		$ui/CharacterPanel.visible = true
		$ui/QuestPanel.visible = false
	elif $ui/CharacterPanel.visible == true:
		$ui/CharacterPanel.visible = false

func _on_str_pressed():
	$Click.play()
	points -= 1
	strength += 1
	#damage += strength*2
	#max_health += strength*10
	_update()
func _on_agi_pressed():
	$Click.play()
	points -= 1
	agility += 1
	#speed_action = 1+((agility/5)/10)
	#speed = 120+(agility)
	_update()
func _on_int_pressed():
	$Click.play()
	points -= 1
	intellect += 1
	#max_originium = 100+(intellect*5)
	_update()



func _on_inventory_pressed():
	$Click.play()
	$ui/InventoryPanel/Panel/Inventory/CtrlInventoryGridEx.deselect_inventory_item()
	if $ui/InventoryPanel.visible == false:
		$ui/InventoryPanel.visible = true
		$ui/AbilityPanel.visible = false
	elif $ui/InventoryPanel.visible == true:
		$ui/InventoryPanel.visible = false

func _on_main_weapon_item_set(item):
	if not item.get_property("type") == "weapon":
		$ui/InventoryPanel/Panel/Equipment/MainWeapon2.transfer(item, $ui/InventoryPanel/Panel/Inventory/InventoryGrid)
		MainWeapon.equipped_item = 0
		#MainWeapon.reset()
	else:
		if loadingCharacter == false:
			$Equip.play()
		$ui/InventoryPanel/Panel/Equipment/MainWeapon2.sort()
		Events.emit_signal("change_weapon", item)
		if item.get_property("pdef"):
			PDef_weapon = item.get_property("pdef")
			PDef = PDef+item.get_property("pdef")
		if item.get_property("mdef"):
			MDef_weapon = item.get_property("mdef")
			MDef = MDef+item.get_property("mdef")
		if item.get_property("dmg"):
			damage_weapon = item.get_property("dmg")
			damage = damage+item.get_property("dmg")
		if item.get_property("str"):
			strength_weapon = item.get_property("str")
			strength = strength+item.get_property("str")
		if item.get_property("agi"):
			agility_weapon = item.get_property("agi")
			agility = agility+item.get_property("agi")
		if item.get_property("int"):
			intellect_weapon = item.get_property("int")
			intellect = intellect+item.get_property("int")
		if item.get_property("hp"):
			max_health_weapon = item.get_property("hp")
			max_health = max_health+item.get_property("hp")
		if item.get_property("orig"):
			max_originium_weapon = item.get_property("orig")
			max_originium = max_originium+item.get_property("orig")
		_update()
func _on_body_armor_item_set(item):
	if not item.get_property("type") == "bodyarmor":
		$ui/InventoryPanel/Panel/Equipment/BodyArmor2.transfer(item, $ui/InventoryPanel/Panel/Inventory/InventoryGrid)
		BodyArmor.equipped_item = 0
		#BodyArmor.reset()
	else:
		if loadingCharacter == false:
			$Equip.play()
		$ui/InventoryPanel/Panel/Equipment/BodyArmor2.sort()
		Events.emit_signal("change_bodyarmor", item)
		if item.get_property("pdef"):
			PDef_armor = item.get_property("pdef")
			PDef = PDef+item.get_property("pdef")
		if item.get_property("mdef"):
			MDef_armor = item.get_property("mdef")
			MDef = MDef+item.get_property("mdef")
		if item.get_property("dmg"):
			damage_armor = item.get_property("dmg")
			damage = damage+item.get_property("dmg")
		if item.get_property("str"):
			strength_armor = item.get_property("str")
			strength = strength+item.get_property("str")
		if item.get_property("agi"):
			agility_armor = item.get_property("agi")
			agility = agility+item.get_property("agi")
		if item.get_property("int"):
			intellect_armor = item.get_property("int")
			intellect = intellect+item.get_property("int")
		if item.get_property("hp"):
			max_health_armor = item.get_property("hp")
			max_health = max_health+item.get_property("hp")
		if item.get_property("orig"):
			max_originium_armor = item.get_property("orig")
			max_originium = max_originium+item.get_property("orig")
		_update()
func _on_helmet_item_set(item):
	if not item.get_property("type") == "helmet":
		$ui/InventoryPanel/Panel/Equipment/Helmet2.transfer(item, $ui/InventoryPanel/Panel/Inventory/InventoryGrid)
		Helmet.equipped_item = 0
		#Helmet.reset()
	else:
		if loadingCharacter == false:
			$Equip.play()
		$ui/InventoryPanel/Panel/Equipment/Helmet2.sort()
		Events.emit_signal("change_helmet", item)
		if item.get_property("pdef"):
			PDef_helmet = item.get_property("pdef")
			PDef = PDef+item.get_property("pdef")
		if item.get_property("mdef"):
			MDef_helmet = item.get_property("mdef")
			MDef = MDef+item.get_property("mdef")
		if item.get_property("dmg"):
			damage_helmet = item.get_property("dmg")
			damage = damage+item.get_property("dmg")
		if item.get_property("str"):
			strength_helmet = item.get_property("str")
			strength = strength+item.get_property("str")
		if item.get_property("agi"):
			agility_helmet = item.get_property("agi")
			agility = agility+item.get_property("agi")
		if item.get_property("int"):
			intellect_helmet = item.get_property("int")
			intellect = intellect+item.get_property("int")
		if item.get_property("hp"):
			max_health_helmet = item.get_property("hp")
			max_health = max_health+item.get_property("hp")
		if item.get_property("orig"):
			max_originium_helmet = item.get_property("orig")
			max_originium = max_originium+item.get_property("orig")
		_update()
func _on_gear_item_set(item):
	if not item.get_property("type") == "gear":
		$ui/InventoryPanel/Panel/Equipment/Gear2.transfer(item, $ui/InventoryPanel/Panel/Inventory/InventoryGrid)
		Gear.equipped_item = 0
		#Helmet.reset()
	else:
		if loadingCharacter == false:
			$Equip.play()
		$ui/InventoryPanel/Panel/Equipment/Gear2.sort()
		Events.emit_signal("change_gear", item)
		if item.get_property("pdef"):
			PDef_gear = item.get_property("pdef")
			PDef = PDef+item.get_property("pdef")
		if item.get_property("mdef"):
			MDef_gear = item.get_property("mdef")
			MDef = MDef+item.get_property("mdef")
		if item.get_property("dmg"):
			damage_gear = item.get_property("dmg")
			damage = damage+item.get_property("dmg")
		if item.get_property("str"):
			strength_gear = item.get_property("str")
			strength = strength+item.get_property("str")
		if item.get_property("agi"):
			agility_gear = item.get_property("agi")
			agility = agility+item.get_property("agi")
		if item.get_property("int"):
			intellect_gear = item.get_property("int")
			intellect = intellect+item.get_property("int")
		if item.get_property("hp"):
			max_health_gear = item.get_property("hp")
			max_health = max_health+item.get_property("hp")
		if item.get_property("orig"):
			max_originium_gear = item.get_property("orig")
			max_originium = max_originium+item.get_property("orig")
		_update()

func _on_main_weapon_2_item_added(item):
	if not MainWeapon_item == null and item.get_property("type") == "weapon":
		$ui/InventoryPanel/Panel/Equipment/MainWeapon2.transfer(MainWeapon_item, $ui/InventoryPanel/Panel/Inventory/InventoryGrid)
		MainWeapon_item = null
	if item.get_property("type") == "weapon":
		MainWeapon_item = item
func _on_body_armor_2_item_added(item):
	if not BodyArmor_item == null and item.get_property("type") == "bodyarmor":
		$ui/InventoryPanel/Panel/Equipment/BodyArmor2.transfer(BodyArmor_item, $ui/InventoryPanel/Panel/Inventory/InventoryGrid)
		BodyArmor_item = null
	if item.get_property("type") == "bodyarmor":
		BodyArmor_item = item
func _on_helmet_2_item_added(item):
	if not Helmet_item == null and item.get_property("type") == "helmet":
		$ui/InventoryPanel/Panel/Equipment/Helmet2.transfer(Helmet_item, $ui/InventoryPanel/Panel/Inventory/InventoryGrid)
		Helmet_item = null
	if item.get_property("type") == "helmet":
		Helmet_item = item
func _on_gear_2_item_added(item):
	if not Gear_item == null and item.get_property("type") == "gear":
		$ui/InventoryPanel/Panel/Equipment/Gear2.transfer(Gear_item, $ui/InventoryPanel/Panel/Inventory/InventoryGrid)
		Gear_item = null
	if item.get_property("type") == "gear":
		Gear_item = item

func _on_main_weapon_item_cleared():
	if has_node("ui/InventoryPanel/Panel/Equipment/MainWeapon2"):
		if not $ui/InventoryPanel/Panel/Equipment/MainWeapon2 == null:
			$Click.play()
			$ui/InventoryPanel/Panel/Equipment/MainWeapon2.transfer(MainWeapon_item, $ui/InventoryPanel/Panel/Inventory/InventoryGrid)
			MainWeapon_item = null
			if damage_weapon > 0:
				damage = damage - damage_weapon
				damage_weapon = 0
			if PDef_weapon > 0:
				PDef = PDef - PDef_weapon
				PDef_weapon = 0
			if MDef_weapon > 0:
				MDef = MDef - MDef_weapon
				MDef_weapon = 0
			if strength_weapon > 0:
				strength = strength - strength_weapon
				strength_weapon = 0
			if agility_weapon > 0:
				agility = agility - agility_weapon
				agility_weapon = 0
			if intellect_weapon > 0:
				intellect = intellect - intellect_weapon
				intellect_weapon = 0
			if max_health_weapon > 0:
				max_health = max_health - max_health_weapon
				max_health_weapon = 0
			if max_originium_weapon > 0:
				max_originium = max_originium - max_originium_weapon
				max_originium_weapon = 0
			_update()
	else:
		print("	_on_main_weapon_item_cleared() пошло по жопе!")
func _on_body_armor_item_cleared():
	if has_node("ui/InventoryPanel/Panel/Equipment/BodyArmor2"):
		if not $ui/InventoryPanel/Panel/Equipment/BodyArmor2 == null:
			$Click.play()
			$ui/InventoryPanel/Panel/Equipment/BodyArmor2.transfer(BodyArmor_item, $ui/InventoryPanel/Panel/Inventory/InventoryGrid)
			BodyArmor_item = null
			if damage_armor > 0:
				damage = damage - damage_armor
				damage_armor = 0
			if PDef_armor > 0:
				PDef = PDef - PDef_armor
				PDef_armor = 0
			if MDef_armor > 0:
				MDef = MDef - MDef_armor
				MDef_armor = 0
			if strength_armor > 0:
				strength = strength - strength_armor
				strength_armor = 0
			if agility_armor > 0:
				agility = agility - agility_armor
				agility_armor = 0
			if intellect_armor > 0:
				intellect = intellect - intellect_armor
				intellect_armor = 0
			if max_health_armor > 0:
				max_health = max_health - max_health_armor
				max_health_armor = 0
			if max_originium_armor > 0:
				max_originium = max_originium - max_originium_armor
				max_originium_armor = 0
			_update()
	else:
		print("	_on_body_armor_item_cleared() пошло по жопе!")
func _on_helmet_item_cleared():
	if has_node("ui/InventoryPanel/Panel/Equipment/Helmet2"):
		if not $ui/InventoryPanel/Panel/Equipment/Helmet2 == null:
			$Click.play()
			$ui/InventoryPanel/Panel/Equipment/Helmet2.transfer(Helmet_item, $ui/InventoryPanel/Panel/Inventory/InventoryGrid)
			Helmet_item = null
			if damage_helmet > 0:
				damage = damage - damage_helmet
				damage_helmet = 0
			if PDef_helmet > 0:
				PDef = PDef - PDef_helmet
				PDef_helmet = 0
			if MDef_helmet > 0:
				MDef = MDef - MDef_helmet
				MDef_helmet = 0
			if strength_helmet > 0:
				strength = strength - strength_helmet
				strength_helmet = 0
			if agility_helmet > 0:
				agility = agility - agility_helmet
				agility_helmet = 0
			if intellect_helmet > 0:
				intellect = intellect - intellect_helmet
				intellect_helmet = 0
			if max_health_helmet > 0:
				max_health = max_health - max_health_helmet
				max_health_helmet = 0
			if max_originium_helmet > 0:
				max_originium = max_originium - max_originium_helmet
				max_originium_helmet = 0
			_update()
	else:
		print("	_on_helmet_item_cleared() пошло по жопе!")
func _on_gear_item_cleared():
	if has_node("ui/InventoryPanel/Panel/Equipment/Gear2"):
		if not $ui/InventoryPanel/Panel/Equipment/Gear2 == null:
			$Click.play()
			$ui/InventoryPanel/Panel/Equipment/Gear2.transfer(Gear_item, $ui/InventoryPanel/Panel/Inventory/InventoryGrid)
			Gear_item = null
			if damage_gear > 0:
				damage = damage - damage_gear
				damage_gear = 0
			if PDef_gear > 0:
				PDef = PDef - PDef_gear
				PDef_gear = 0
			if MDef_gear > 0:
				MDef = MDef - MDef_gear
				MDef_gear = 0
			if strength_gear > 0:
				strength = strength - strength_gear
				strength_gear = 0
			if agility_gear > 0:
				agility = agility - agility_gear
				agility_gear = 0
			if intellect_gear > 0:
				intellect = intellect - intellect_gear
				intellect_gear = 0
			if max_health_gear > 0:
				max_health = max_health - max_health_gear
				max_health_gear = 0
			if max_originium_gear > 0:
				max_originium = max_originium - max_originium_gear
				max_originium_gear = 0
			_update()
	else:
		print("	_on_gear_item_cleared() пошло по жопе!")

func _on_ctrl_inventory_grid_ex_selection_changed():
	if has_node("ui/InventoryPanel/Panel/Inventory/CtrlInventoryGridEx"):
		var item2 = $ui/InventoryPanel/Panel/Inventory/CtrlInventoryGridEx.get_selected_inventory_item()
		var _hz1
		var _hz2
		var _hz3
		var _hz4; var _hz5; var _hz6
		if not item2 == null:
			$Select.play()
			$ui/InventoryPanel/Panel/Inventory/Item_Per/ItemName.text = item2.get_property("name")
			# Первый слот #
			if item2.get_property("dmg"):
				$ui/InventoryPanel/Panel/Inventory/Item_Per/Pers1/Per1.text = "Урон: " + str(item2.get_property("dmg"))
				_hz1 = "dmg"
			elif item2.get_property("pdef"):
				$ui/InventoryPanel/Panel/Inventory/Item_Per/Pers1/Per1.text = "Физ.Защита: " + str(item2.get_property("pdef"))
				_hz1 = "pdef"
			elif item2.get_property("mdef"):
				$ui/InventoryPanel/Panel/Inventory/Item_Per/Pers1/Per1.text = "Маг.Защита: " + str(item2.get_property("mdef"))
				_hz1 = "mdef"
			else:
				$ui/InventoryPanel/Panel/Inventory/Item_Per/Pers1/Per1.text = ""
				_hz1 = null
			# Второй слот #
			if item2.get_property("pdef") and not _hz1 == "pdef":
				$ui/InventoryPanel/Panel/Inventory/Item_Per/Pers1/Per2.text = "Физ.Защита: " + str(item2.get_property("pdef"))
				_hz2 = "pdef"
			elif item2.get_property("mdef") and not _hz1 == "mdef":
				$ui/InventoryPanel/Panel/Inventory/Item_Per/Pers1/Per2.text = "Маг.Защита: " + str(item2.get_property("mdef"))
				_hz2 = "mdef"
			else:
				$ui/InventoryPanel/Panel/Inventory/Item_Per/Pers1/Per2.text = ""
				_hz2 = null
			# Третий слот #
			if item2.get_property("mdef") and not _hz2 == "mdef" and not _hz1 == "mdef":
				$ui/InventoryPanel/Panel/Inventory/Item_Per/Pers1/Per3.text = "Маг.Защита: " + str(item2.get_property("mdef"))
				_hz3 = "mdef"
			else:
				$ui/InventoryPanel/Panel/Inventory/Item_Per/Pers1/Per3.text = ""
				_hz3 = null
			#
			#
			#
			if item2.get_property("str"):
				$ui/InventoryPanel/Panel/Inventory/Item_Per/Pers2/Per1.text = "Сила: " + str(item2.get_property("str"))
				_hz4 = "str"
			elif item2.get_property("agi"):
				$ui/InventoryPanel/Panel/Inventory/Item_Per/Pers2/Per1.text = "Ловкость: " + str(item2.get_property("agi"))
				_hz4 = "agi"
			elif item2.get_property("int"):
				$ui/InventoryPanel/Panel/Inventory/Item_Per/Pers2/Per1.text = "Интеллект: " + str(item2.get_property("int"))
				_hz4 = "int"
			else:
				$ui/InventoryPanel/Panel/Inventory/Item_Per/Pers2/Per1.text = ""
				_hz4 = null
			if item2.get_property("agi") and not _hz4 == "agi":
				$ui/InventoryPanel/Panel/Inventory/Item_Per/Pers2/Per2.text = "Ловкость: " + str(item2.get_property("agi"))
				_hz5 = "agi"
			elif item2.get_property("int") and not _hz4 == "int":
				$ui/InventoryPanel/Panel/Inventory/Item_Per/Pers2/Per2.text = "Интеллект: " + str(item2.get_property("int"))
				_hz5 = "int"
			else:
				$ui/InventoryPanel/Panel/Inventory/Item_Per/Pers2/Per2.text = ""
				_hz5 = null
			if item2.get_property("int") and not _hz4 == "int" and not _hz5 == "int":
				$ui/InventoryPanel/Panel/Inventory/Item_Per/Pers2/Per3.text = "Интеллект: " + str(item2.get_property("int"))
				_hz6 = "int"
			else:
				$ui/InventoryPanel/Panel/Inventory/Item_Per/Pers2/Per3.text = ""
				_hz6 = null
		else:
			$ui/InventoryPanel/Panel/Inventory/Item_Per/ItemName.text = ""
			$ui/InventoryPanel/Panel/Inventory/Item_Per/Pers1/Per1.text = ""
			$ui/InventoryPanel/Panel/Inventory/Item_Per/Pers1/Per2.text = ""
			$ui/InventoryPanel/Panel/Inventory/Item_Per/Pers1/Per3.text = ""
			$ui/InventoryPanel/Panel/Inventory/Item_Per/Pers1/Per4.text = ""
			$ui/InventoryPanel/Panel/Inventory/Item_Per/Pers2/Per1.text = ""
			$ui/InventoryPanel/Panel/Inventory/Item_Per/Pers2/Per2.text = ""
			$ui/InventoryPanel/Panel/Inventory/Item_Per/Pers2/Per3.text = ""
			$ui/InventoryPanel/Panel/Inventory/Item_Per/Pers2/Per4.text = ""
		if DClick == true:
			await get_tree().create_timer(0.1).timeout
			var item1 = $ui/InventoryPanel/Panel/Inventory/CtrlInventoryGridEx.get_selected_inventory_item()
			if not item1 == null:
				if item1.get_property("type") == "weapon":
					$ui/InventoryPanel/Panel/Inventory/InventoryGrid.transfer(item1, $ui/InventoryPanel/Panel/Equipment/MainWeapon2)
					MainWeapon.equipped_item = 0
				if item1.get_property("type") == "bodyarmor":
					$ui/InventoryPanel/Panel/Inventory/InventoryGrid.transfer(item1, $ui/InventoryPanel/Panel/Equipment/BodyArmor2)
					BodyArmor.equipped_item = 0
				if item1.get_property("type") == "helmet":
					$ui/InventoryPanel/Panel/Inventory/InventoryGrid.transfer(item1, $ui/InventoryPanel/Panel/Equipment/Helmet2)
					Helmet.equipped_item = 0
				if item1.get_property("type") == "gear":
					$ui/InventoryPanel/Panel/Inventory/InventoryGrid.transfer(item1, $ui/InventoryPanel/Panel/Equipment/Gear2)
					Gear.equipped_item = 0
	else:
		print("	_on_ctrl_inventory_grid_ex_selection_changed() пошло по жопе!")

func _on_drop_zone_mouse_entered():
	in_drop_zone = true
func _on_drop_zone_mouse_exited():
	in_drop_zone = false



func _on_ability_pressed():
	$Click.play()
	if $ui/AbilityPanel.visible == false:
		$ui/AbilityPanel.visible = true
		$ui/InventoryPanel.visible = false
	elif $ui/AbilityPanel.visible == true:
		$ui/AbilityPanel.visible = false

func _on_panel_mouse_entered():
	print("1")
	in_gui = true
	if not $ui/AbilityPanel.AbilityActive1 == null:
		$ui/AbilityPanel.AbilityActive1.can_activate = false
	if not $ui/AbilityPanel.AbilityActive2 == null:
		$ui/AbilityPanel.AbilityActive2.can_activate = false
func _on_panel_mouse_exited():
	print("2")
	in_gui = false
	if not $ui/AbilityPanel.AbilityActive1 == null:
		$ui/AbilityPanel.AbilityActive1.can_activate = true
	if not $ui/AbilityPanel.AbilityActive2 == null:
		$ui/AbilityPanel.AbilityActive2.can_activate = true


func _on_player_inventory_shop_selection_changed():
	var item2 = $ui/Shop/PlayerInventory/PlayerInventoryShop.get_selected_inventory_item()
	var _hz1; var _hz2; var _hz3; var _hz4; var _hz5; var _hz6
	if not item2 == null:
		$Select.play()
		$ui/Shop/PlayerInventory/Item_Per/ItemName.text = item2.get_property("name")
		$ui/Shop/PlayerInventory/Money.text = str(item2.get_property("sell"))
		# Первый слот #
		if item2.get_property("dmg"):
			$ui/Shop/PlayerInventory/Item_Per/Pers1/Per1.text = "Урон: " + str(item2.get_property("dmg"))
			_hz1 = "dmg"
		elif item2.get_property("pdef"):
			$ui/Shop/PlayerInventory/Item_Per/Pers1/Per1.text = "Физ.Защита: " + str(item2.get_property("pdef"))
			_hz1 = "pdef"
		elif item2.get_property("mdef"):
			$ui/Shop/PlayerInventory/Item_Per/Pers1/Per1.text = "Маг.Защита: " + str(item2.get_property("mdef"))
			_hz1 = "mdef"
		else:
			$ui/Shop/PlayerInventory/Item_Per/Pers1/Per1.text = ""
			_hz1 = null
		# Второй слот #
		if item2.get_property("pdef") and not _hz1 == "pdef":
			$ui/Shop/PlayerInventory/Item_Per/Pers1/Per2.text = "Физ.Защита: " + str(item2.get_property("pdef"))
			_hz2 = "pdef"
		elif item2.get_property("mdef") and not _hz1 == "mdef":
			$ui/Shop/PlayerInventory/Item_Per/Pers1/Per2.text = "Маг.Защита: " + str(item2.get_property("mdef"))
			_hz2 = "mdef"
		else:
			$ui/Shop/PlayerInventory/Item_Per/Pers1/Per2.text = ""
			_hz2 = null
		# Третий слот #
		if item2.get_property("mdef") and not _hz2 == "mdef" and not _hz1 == "mdef":
			$ui/Shop/PlayerInventory/Item_Per/Pers1/Per3.text = "Маг.Защита: " + str(item2.get_property("mdef"))
			_hz3 = "mdef"
		else:
			$ui/Shop/PlayerInventory/Item_Per/Pers1/Per3.text = ""
			_hz3 = null
		#
		#
		#
		if item2.get_property("str"):
			$ui/Shop/PlayerInventory/Item_Per/Pers2/Per1.text = "Сила: " + str(item2.get_property("str"))
			_hz4 = "str"
		elif item2.get_property("agi"):
			$ui/Shop/PlayerInventory/Item_Per/Pers2/Per1.text = "Ловкость: " + str(item2.get_property("agi"))
			_hz4 = "agi"
		elif item2.get_property("int"):
			$ui/Shop/PlayerInventory/Item_Per/Pers2/Per1.text = "Интеллект: " + str(item2.get_property("int"))
			_hz4 = "int"
		else:
			$ui/Shop/PlayerInventory/Item_Per/Pers2/Per1.text = ""
			_hz4 = null
		if item2.get_property("agi") and not _hz4 == "agi":
			$ui/Shop/PlayerInventory/Item_Per/Pers2/Per2.text = "Ловкость: " + str(item2.get_property("agi"))
			_hz5 = "agi"
		elif item2.get_property("int") and not _hz4 == "int":
			$ui/Shop/PlayerInventory/Item_Per/Pers2/Per2.text = "Интеллект: " + str(item2.get_property("int"))
			_hz5 = "int"
		else:
			$ui/Shop/PlayerInventory/Item_Per/Pers2/Per2.text = ""
			_hz5 = null
		if item2.get_property("int") and not _hz4 == "int" and not _hz5 == "int":
			$ui/Shop/PlayerInventory/Item_Per/Pers2/Per3.text = "Интеллект: " + str(item2.get_property("int"))
			_hz6 = "int"
		else:
			$ui/Shop/PlayerInventory/Item_Per/Pers2/Per3.text = ""
			_hz6 = null
	else:
		$ui/Shop/PlayerInventory/Item_Per/ItemName.text = ""
		$ui/Shop/PlayerInventory/Money.text = ""
		$ui/Shop/PlayerInventory/Item_Per/Pers1/Per1.text = ""
		$ui/Shop/PlayerInventory/Item_Per/Pers1/Per2.text = ""
		$ui/Shop/PlayerInventory/Item_Per/Pers1/Per3.text = ""
		$ui/Shop/PlayerInventory/Item_Per/Pers1/Per4.text = ""
		$ui/Shop/PlayerInventory/Item_Per/Pers2/Per1.text = ""
		$ui/Shop/PlayerInventory/Item_Per/Pers2/Per2.text = ""
		$ui/Shop/PlayerInventory/Item_Per/Pers2/Per3.text = ""
		$ui/Shop/PlayerInventory/Item_Per/Pers2/Per4.text = ""
func _on_seller_inventory_shop_selection_changed():
	var item2 = $ui/Shop/SellerInventory/SellerInventoryShop.get_selected_inventory_item()
	var _hz1; var _hz2; var _hz3; var _hz4; var _hz5; var _hz6
	if not item2 == null:
		$Select.play()
		$ui/Shop/SellerInventory/Item_Per/ItemName.text = item2.get_property("name")
		$ui/Shop/SellerInventory/Money.text = str(item2.get_property("buy"))
		# Первый слот #
		if item2.get_property("dmg"):
			$ui/Shop/SellerInventory/Item_Per/Pers1/Per1.text = "Урон: " + str(item2.get_property("dmg"))
			_hz1 = "dmg"
		elif item2.get_property("pdef"):
			$ui/Shop/SellerInventory/Item_Per/Pers1/Per1.text = "Физ.Защита: " + str(item2.get_property("pdef"))
			_hz1 = "pdef"
		elif item2.get_property("mdef"):
			$ui/Shop/SellerInventory/Item_Per/Pers1/Per1.text = "Маг.Защита: " + str(item2.get_property("mdef"))
			_hz1 = "mdef"
		else:
			$ui/Shop/SellerInventory/Item_Per/Pers1/Per1.text = ""
			_hz1 = null
		# Второй слот #
		if item2.get_property("pdef") and not _hz1 == "pdef":
			$ui/Shop/SellerInventory/Item_Per/Pers1/Per2.text = "Физ.Защита: " + str(item2.get_property("pdef"))
			_hz2 = "pdef"
		elif item2.get_property("mdef") and not _hz1 == "mdef":
			$ui/Shop/SellerInventory/Item_Per/Pers1/Per2.text = "Маг.Защита: " + str(item2.get_property("mdef"))
			_hz2 = "mdef"
		else:
			$ui/Shop/SellerInventory/Item_Per/Pers1/Per2.text = ""
			_hz2 = null
		# Третий слот #
		if item2.get_property("mdef") and not _hz2 == "mdef" and not _hz1 == "mdef":
			$ui/Shop/SellerInventory/Item_Per/Pers1/Per3.text = "Маг.Защита: " + str(item2.get_property("mdef"))
			_hz3 = "mdef"
		else:
			$ui/Shop/SellerInventory/Item_Per/Pers1/Per3.text = ""
			_hz3 = null
		#
		#
		#
		if item2.get_property("str"):
			$ui/Shop/SellerInventory/Item_Per/Pers2/Per1.text = "Сила: " + str(item2.get_property("str"))
			_hz4 = "str"
		elif item2.get_property("agi"):
			$ui/Shop/SellerInventory/Item_Per/Pers2/Per1.text = "Ловкость: " + str(item2.get_property("agi"))
			_hz4 = "agi"
		elif item2.get_property("int"):
			$ui/Shop/SellerInventory/Item_Per/Pers2/Per1.text = "Интеллект: " + str(item2.get_property("int"))
			_hz4 = "int"
		else:
			$ui/Shop/SellerInventory/Item_Per/Pers2/Per1.text = ""
			_hz4 = null
		if item2.get_property("agi") and not _hz4 == "agi":
			$ui/Shop/SellerInventory/Item_Per/Pers2/Per2.text = "Ловкость: " + str(item2.get_property("agi"))
			_hz5 = "agi"
		elif item2.get_property("int") and not _hz4 == "int":
			$ui/Shop/SellerInventory/Item_Per/Pers2/Per2.text = "Интеллект: " + str(item2.get_property("int"))
			_hz5 = "int"
		else:
			$ui/Shop/SellerInventory/Item_Per/Pers2/Per2.text = ""
			_hz5 = null
		if item2.get_property("int") and not _hz4 == "int" and not _hz5 == "int":
			$ui/Shop/SellerInventory/Item_Per/Pers2/Per3.text = "Интеллект: " + str(item2.get_property("int"))
			_hz6 = "int"
		else:
			$ui/Shop/SellerInventory/Item_Per/Pers2/Per3.text = ""
			_hz6 = null
	else:
		$ui/Shop/SellerInventory/Item_Per/ItemName.text = ""
		$ui/Shop/SellerInventory/Money.text = ""
		$ui/Shop/SellerInventory/Item_Per/Pers1/Per1.text = ""
		$ui/Shop/SellerInventory/Item_Per/Pers1/Per2.text = ""
		$ui/Shop/SellerInventory/Item_Per/Pers1/Per3.text = ""
		$ui/Shop/SellerInventory/Item_Per/Pers1/Per4.text = ""
		$ui/Shop/SellerInventory/Item_Per/Pers2/Per1.text = ""
		$ui/Shop/SellerInventory/Item_Per/Pers2/Per2.text = ""
		$ui/Shop/SellerInventory/Item_Per/Pers2/Per3.text = ""
		$ui/Shop/SellerInventory/Item_Per/Pers2/Per4.text = ""

func _on_shop_button_pressed():
	ShopFunc()

func ShopFunc():
	var PlayerInv1 = $ui/InventoryPanel/Panel/Inventory/InventoryGrid
	var PlayerInv2 = $ui/Shop/PlayerInventory/InventoryGrid
	if Events.inShop == false:
		Events.inShop = true
		_update()
		
		$ui/Shop.visible = true
		$ui/Shop/PlayerInventory/PlayerMoney.text = str(money)
		BuyingSelling = false
		PlayerInv2.deserialize(PlayerInv1.serialize())
		BuyingSelling = true
		
		#$ui/Hud.visible = false
		get_tree().paused = true
	else:
		get_tree().paused = false
		
		#print(int($ui/Shop/PlayerInventory/PlayerMoney.text))
		money = int($ui/Shop/PlayerInventory/PlayerMoney.text)
		Events.inShop = false
		$ui/Shop.visible = false
		$ui/Shop/PlayerInventory/Money.text = ""
		BuyingSelling = false
		PlayerInv1.deserialize(PlayerInv2.serialize())
		BuyingSelling = true
		
		_update()
		$ui/Hud.visible = true

func _on_seller_grid_1_item_added(item):
	var free_place = $ui/Shop/SellerInventory/SellerGrid1.find_free_place(item)
	$ui/Shop/SellerInventory/SellerGrid1.move_item_to(item, Vector2i(free_place["position"]))
	print(free_place["position"])
	if BuyingSelling == true:
		$Click.play()
		money += item.get_property("sell")
		$ui/Shop/PlayerInventory/PlayerMoney.text = str(money)
	$ui/Shop/SellerInventory/SellerGrid1.sort()
func _on_player_grid_1_item_added(item):
	if BuyingSelling == true:
		if money >= item.get_property("buy"):
			$Click.play()
			money -= item.get_property("buy")
			$ui/Shop/PlayerInventory/PlayerMoney.text = str(money)
		else:
			BuyingSelling = false
			$ui/Shop/PlayerInventory/InventoryGrid.transfer(item, $ui/Shop/SellerInventory/SellerGrid1)
			var free_place = $ui/Shop/SellerInventory/SellerGrid1.find_free_place(item)
			$ui/Shop/SellerInventory/SellerGrid1.move_item_to(item, Vector2i(free_place["position"]))
			#print(free_place["position"])
			BuyingSelling = true
			$ui/Shop/SellerInventory/SellerGrid1.sort()



func _on_quest_pressed():
	$Click.play()
	if $ui/QuestPanel.visible == false:
		$ui/QuestPanel.visible = true
		$ui/CharacterPanel.visible = false
	elif $ui/QuestPanel.visible == true:
		$ui/QuestPanel.visible = false



func _on_continue_pressed():
	$Click.play()
	get_tree().paused = false
	$ui/Menu.visible = false
func _on_exit_pressed():
	$Click.play()
	$ui/InventoryPanel/Panel/Inventory/CtrlInventoryGridEx.deselect_inventory_item()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://MainMenu.tscn")

func _on_back_pressed():
	$Click.play()
	$ui/Menu/Continue.visible = true
	$ui/Menu/Save.visible = true
	$ui/Menu/Load.visible = true
	$ui/Menu/Exit.visible = true
	
	$ui/Menu/Save1.visible = false
	$ui/Menu/Save2.visible = false
	$ui/Menu/Save3.visible = false
	$ui/Menu/Back.visible = false
func _on_save_pressed():
	$Click.play()
	$ui/Menu/Continue.visible = false
	$ui/Menu/Save.visible = false
	$ui/Menu/Load.visible = false
	$ui/Menu/Exit.visible = false
	
	$ui/Menu/Save1.visible = true
	$ui/Menu/Save2.visible = true
	$ui/Menu/Save3.visible = true
	$ui/Menu/Back.visible = true


func _on_save_1_pressed():
	$Click.play()
	Events.activeSave = "Save1"
	Events.PlayerSave(get_tree().get_nodes_in_group("player"))
	Events.activeSave = Events.activeSaveReturn
	$ui/Menu/Continue.visible = true
	$ui/Menu/Save.visible = true
	$ui/Menu/Load.visible = true
	$ui/Menu/Exit.visible = true
	$ui/Menu/Save1.visible = false
	$ui/Menu/Save2.visible = false
	$ui/Menu/Save3.visible = false
	$ui/Menu/Back.visible = false
	get_tree().paused = false
	$ui/Menu.visible = false
func _on_save_2_pressed():
	$Click.play()
	Events.activeSave = "Save2"
	Events.PlayerSave(get_tree().get_nodes_in_group("player"))
	Events.activeSave = Events.activeSaveReturn
	$ui/Menu/Continue.visible = true
	$ui/Menu/Save.visible = true
	$ui/Menu/Load.visible = true
	$ui/Menu/Exit.visible = true
	$ui/Menu/Save1.visible = false
	$ui/Menu/Save2.visible = false
	$ui/Menu/Save3.visible = false
	$ui/Menu/Back.visible = false
	get_tree().paused = false
	$ui/Menu.visible = false
func _on_save_3_pressed():
	$Click.play()
	Events.activeSave = "Save3"
	Events.PlayerSave(get_tree().get_nodes_in_group("player"))
	Events.activeSave = Events.activeSaveReturn
	$ui/Menu/Continue.visible = true
	$ui/Menu/Save.visible = true
	$ui/Menu/Load.visible = true
	$ui/Menu/Exit.visible = true
	$ui/Menu/Save1.visible = false
	$ui/Menu/Save2.visible = false
	$ui/Menu/Save3.visible = false
	$ui/Menu/Back.visible = false
	get_tree().paused = false
	$ui/Menu.visible = false



func ChestFunc():
	var PlayerInv1 = $ui/InventoryPanel/Panel/Inventory/InventoryGrid
	var PlayerInv2 = $ui/Chest/PlayerInventory/InventoryGrid
	if Events.inChest == false:
		Events.inChest = true
		_update()
		
		$ui/Chest.visible = true
		BuyingSelling = false
		PlayerInv2.deserialize(PlayerInv1.serialize())
		BuyingSelling = true
		
		if FileAccess.file_exists("user://Save/"+Events.activeSave+"/PerChest.json") == true:
			var Inv = load("user://Save/"+Events.activeSave+"/PerChest.json")
			var PlayerInv = $ui/Chest/ChestInventory/ChestGrid
			PlayerInv.deserialize(Inv.data)
		
		#$ui/Hud.visible = false
		get_tree().paused = true
	else:
		get_tree().paused = false
		
		Events.inChest = false
		$ui/Chest.visible = false
		#$ui/Chest/PlayerInventory/Money.text = ""
		BuyingSelling = false
		PlayerInv1.deserialize(PlayerInv2.serialize())
		BuyingSelling = true
		
		var InvData = $ui/Chest/ChestInventory/ChestGrid.serialize()
		var InvPack = JSON.new()
		InvPack.set_data(InvData)
		ResourceSaver.save(InvPack, "user://Save/"+Events.activeSave+"/PerChest.json")
		
		_update()
		$ui/Hud.visible = true
func _on_player_inventory_selection_changed():
	$Select.play()
	var item2 = $ui/Chest/PlayerInventory/PlayerInventory.get_selected_inventory_item()
	var _hz1; var _hz2; var _hz3; var _hz4; var _hz5; var _hz6
	if not item2 == null:
		$ui/Chest/PlayerInventory/Item_Per/ItemName.text = item2.get_property("name")
		#$ui/Chest/PlayerInventory/Money.text = str(item2.get_property("sell"))
		# Первый слот #
		if item2.get_property("dmg"):
			$ui/Chest/PlayerInventory/Item_Per/Pers1/Per1.text = "Урон: " + str(item2.get_property("dmg"))
			_hz1 = "dmg"
		elif item2.get_property("pdef"):
			$ui/Chest/PlayerInventory/Item_Per/Pers1/Per1.text = "Физ.Защита: " + str(item2.get_property("pdef"))
			_hz1 = "pdef"
		elif item2.get_property("mdef"):
			$ui/Chest/PlayerInventory/Item_Per/Pers1/Per1.text = "Маг.Защита: " + str(item2.get_property("mdef"))
			_hz1 = "mdef"
		else:
			$ui/Chest/PlayerInventory/Item_Per/Pers1/Per1.text = ""
			_hz1 = null
		# Второй слот #
		if item2.get_property("pdef") and not _hz1 == "pdef":
			$ui/Chest/PlayerInventory/Item_Per/Pers1/Per2.text = "Физ.Защита: " + str(item2.get_property("pdef"))
			_hz2 = "pdef"
		elif item2.get_property("mdef") and not _hz1 == "mdef":
			$ui/Chest/PlayerInventory/Item_Per/Pers1/Per2.text = "Маг.Защита: " + str(item2.get_property("mdef"))
			_hz2 = "mdef"
		else:
			$ui/Chest/PlayerInventory/Item_Per/Pers1/Per2.text = ""
			_hz2 = null
		# Третий слот #
		if item2.get_property("mdef") and not _hz2 == "mdef" and not _hz1 == "mdef":
			$ui/Chest/PlayerInventory/Item_Per/Pers1/Per3.text = "Маг.Защита: " + str(item2.get_property("mdef"))
			_hz3 = "mdef"
		else:
			$ui/Chest/PlayerInventory/Item_Per/Pers1/Per3.text = ""
			_hz3 = null
		#
		#
		#
		if item2.get_property("str"):
			$ui/Chest/PlayerInventory/Item_Per/Pers2/Per1.text = "Сила: " + str(item2.get_property("str"))
			_hz4 = "str"
		elif item2.get_property("agi"):
			$ui/Chest/PlayerInventory/Item_Per/Pers2/Per1.text = "Ловкость: " + str(item2.get_property("agi"))
			_hz4 = "agi"
		elif item2.get_property("int"):
			$ui/Chest/PlayerInventory/Item_Per/Pers2/Per1.text = "Интеллект: " + str(item2.get_property("int"))
			_hz4 = "int"
		else:
			$ui/Chest/PlayerInventory/Item_Per/Pers2/Per1.text = ""
			_hz4 = null
		if item2.get_property("agi") and not _hz4 == "agi":
			$ui/Chest/PlayerInventory/Item_Per/Pers2/Per2.text = "Ловкость: " + str(item2.get_property("agi"))
			_hz5 = "agi"
		elif item2.get_property("int") and not _hz4 == "int":
			$ui/Chest/PlayerInventory/Item_Per/Pers2/Per2.text = "Интеллект: " + str(item2.get_property("int"))
			_hz5 = "int"
		else:
			$ui/Chest/PlayerInventory/Item_Per/Pers2/Per2.text = ""
			_hz5 = null
		if item2.get_property("int") and not _hz4 == "int" and not _hz5 == "int":
			$ui/Chest/PlayerInventory/Item_Per/Pers2/Per3.text = "Интеллект: " + str(item2.get_property("int"))
			_hz6 = "int"
		else:
			$ui/Chest/PlayerInventory/Item_Per/Pers2/Per3.text = ""
			_hz6 = null
	else:
		$ui/Chest/PlayerInventory/Item_Per/ItemName.text = ""
		#$ui/Chest/PlayerInventory/Money.text = ""
		$ui/Chest/PlayerInventory/Item_Per/Pers1/Per1.text = ""
		$ui/Chest/PlayerInventory/Item_Per/Pers1/Per2.text = ""
		$ui/Chest/PlayerInventory/Item_Per/Pers1/Per3.text = ""
		$ui/Chest/PlayerInventory/Item_Per/Pers1/Per4.text = ""
		$ui/Chest/PlayerInventory/Item_Per/Pers2/Per1.text = ""
		$ui/Chest/PlayerInventory/Item_Per/Pers2/Per2.text = ""
		$ui/Chest/PlayerInventory/Item_Per/Pers2/Per3.text = ""
		$ui/Chest/PlayerInventory/Item_Per/Pers2/Per4.text = ""
func _on_chest_inventory_selection_changed():
	$Select.play()
	var item2 = $ui/Chest/ChestInventory/ChestInventory.get_selected_inventory_item()
	var _hz1; var _hz2; var _hz3; var _hz4; var _hz5; var _hz6
	if not item2 == null:
		$ui/Chest/ChestInventory/Item_Per/ItemName.text = item2.get_property("name")
		#$ui/Shop/SellerInventory/Money.text = str(item2.get_property("buy"))
		# Первый слот #
		if item2.get_property("dmg"):
			$ui/Chest/ChestInventory/Item_Per/Pers1/Per1.text = "Урон: " + str(item2.get_property("dmg"))
			_hz1 = "dmg"
		elif item2.get_property("pdef"):
			$ui/Chest/ChestInventory/Item_Per/Pers1/Per1.text = "Физ.Защита: " + str(item2.get_property("pdef"))
			_hz1 = "pdef"
		elif item2.get_property("mdef"):
			$ui/Chest/ChestInventory/Item_Per/Pers1/Per1.text = "Маг.Защита: " + str(item2.get_property("mdef"))
			_hz1 = "mdef"
		else:
			$ui/Chest/ChestInventory/Item_Per/Pers1/Per1.text = ""
			_hz1 = null
		# Второй слот #
		if item2.get_property("pdef") and not _hz1 == "pdef":
			$ui/Chest/ChestInventory/Item_Per/Pers1/Per2.text = "Физ.Защита: " + str(item2.get_property("pdef"))
			_hz2 = "pdef"
		elif item2.get_property("mdef") and not _hz1 == "mdef":
			$ui/Chest/ChestInventory/Item_Per/Pers1/Per2.text = "Маг.Защита: " + str(item2.get_property("mdef"))
			_hz2 = "mdef"
		else:
			$ui/Chest/ChestInventory/Item_Per/Pers1/Per2.text = ""
			_hz2 = null
		# Третий слот #
		if item2.get_property("mdef") and not _hz2 == "mdef" and not _hz1 == "mdef":
			$ui/Chest/ChestInventory/Item_Per/Pers1/Per3.text = "Маг.Защита: " + str(item2.get_property("mdef"))
			_hz3 = "mdef"
		else:
			$ui/Chest/ChestInventory/Item_Per/Pers1/Per3.text = ""
			_hz3 = null
		#
		#
		#
		if item2.get_property("str"):
			$ui/Chest/ChestInventory/Item_Per/Pers2/Per1.text = "Сила: " + str(item2.get_property("str"))
			_hz4 = "str"
		elif item2.get_property("agi"):
			$ui/Chest/ChestInventory/Item_Per/Pers2/Per1.text = "Ловкость: " + str(item2.get_property("agi"))
			_hz4 = "agi"
		elif item2.get_property("int"):
			$ui/Chest/ChestInventory/Item_Per/Pers2/Per1.text = "Интеллект: " + str(item2.get_property("int"))
			_hz4 = "int"
		else:
			$ui/Chest/ChestInventory/Item_Per/Pers2/Per1.text = ""
			_hz4 = null
		if item2.get_property("agi") and not _hz4 == "agi":
			$ui/Chest/ChestInventory/Item_Per/Pers2/Per2.text = "Ловкость: " + str(item2.get_property("agi"))
			_hz5 = "agi"
		elif item2.get_property("int") and not _hz4 == "int":
			$ui/Chest/ChestInventory/Item_Per/Pers2/Per2.text = "Интеллект: " + str(item2.get_property("int"))
			_hz5 = "int"
		else:
			$ui/Chest/ChestInventory/Item_Per/Pers2/Per2.text = ""
			_hz5 = null
		if item2.get_property("int") and not _hz4 == "int" and not _hz5 == "int":
			$ui/Chest/ChestInventory/Item_Per/Pers2/Per3.text = "Интеллект: " + str(item2.get_property("int"))
			_hz6 = "int"
		else:
			$ui/Chest/ChestInventory/Item_Per/Pers2/Per3.text = ""
			_hz6 = null
	else:
		$ui/Chest/ChestInventory/Item_Per/ItemName.text = ""
		#$ui/Chest/ChestInventory/Money.text = ""
		$ui/Chest/ChestInventory/Item_Per/Pers1/Per1.text = ""
		$ui/Chest/ChestInventory/Item_Per/Pers1/Per2.text = ""
		$ui/Chest/ChestInventory/Item_Per/Pers1/Per3.text = ""
		$ui/Chest/ChestInventory/Item_Per/Pers1/Per4.text = ""
		$ui/Chest/ChestInventory/Item_Per/Pers2/Per1.text = ""
		$ui/Chest/ChestInventory/Item_Per/Pers2/Per2.text = ""
		$ui/Chest/ChestInventory/Item_Per/Pers2/Per3.text = ""
		$ui/Chest/ChestInventory/Item_Per/Pers2/Per4.text = ""

func _on_chest_button_pressed():
	ChestFunc()
	walking = true
	talking = false
	ability1 = false
	ability2 = false



func _on_continue_mouse_entered():
	$Select.play()
func _on_save_mouse_entered():
	$Select.play()
func _on_load_mouse_entered():
	$Select.play()
func _on_exit_mouse_entered():
	$Select.play()
func _on_save_1_mouse_entered():
	$Select.play()
func _on_save_2_mouse_entered():
	$Select.play()
func _on_save_3_mouse_entered():
	$Select.play()
func _on_back_mouse_entered():
	$Select.play()
