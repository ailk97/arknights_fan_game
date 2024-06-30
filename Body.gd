extends Node2D

#var armor = preload("res://МашаБроня.png")
var nude = preload("res://Игровые асеты/Character_Base.png")
@onready var sword_texture = $Кисть21/Кисть22/Меч

#@onready var arm = get_node("Кисть21/Кисть22")
#@onready var skirt2 = get_node("Тело/Юбка2")
#@onready var skirt1 = get_node("Тело/Юбка1")
#@onready var sword = get_node("Кисть21/Кисть22/Меч")

@onready var arm = $Кисть21/Кисть22
@onready var skirt2 = $Тело/Юбка2
@onready var skirt1 = $Тело/Юбка1
@onready var sword = $Кисть21/Кисть22/Меч
@onready var gear_texture = $Локоть1/Gear

func _ready():
	Events.connect("change_weapon", changeWeapon)
	Events.connect("change_bodyarmor", changeBodyArmor)
	Events.connect("change_helmet", changeHelmet)
	Events.connect("change_gear", changeGear)

func changeWeapon(item):
	sword.visible = true
	sword_texture.texture = load(item.get_property("texture"))
func changeBodyArmor(item):
	var item_texture_bodyarmor = load(item.get_property("texture"))
	$Плечо2.texture = item_texture_bodyarmor
	$Локоть2.texture = item_texture_bodyarmor
	$Кисть21.texture = item_texture_bodyarmor
	arm.texture = item_texture_bodyarmor
	$ПраваяНога2.texture = item_texture_bodyarmor
	$ПраваяНога1.texture = item_texture_bodyarmor
	$ПраваяСтопа.texture = item_texture_bodyarmor
	$ЛеваяНога2.texture = item_texture_bodyarmor
	$ЛеваяНога1.texture = item_texture_bodyarmor
	$ЛеваяСтопа.texture = item_texture_bodyarmor
	$Тело.texture = item_texture_bodyarmor
	$Плечо1.texture = item_texture_bodyarmor
	$Кисть1.texture = item_texture_bodyarmor
	$Локоть1.texture = item_texture_bodyarmor
	if item.get_property("skirt") == true:
		skirt1.visible = true
		skirt2.visible = true
	else:
		skirt1.visible = false
		skirt2.visible = false
func changeHelmet(item):
	$Голова/Helmet.visible = true
	$Голова/Helmet.texture = load(item.get_property("texture"))
	$Голова/Волосы4.visible = false
	$Голова/Волосы3.visible = false
	$Голова/Волосы2.visible = false
	$Голова/Волосы1.visible = false
func changeGear(item):
	#var gear_jopa = load(item.get_property("texture"))
	gear_texture.texture = load(item.get_property("texture"))
	$Локоть1/Gear.visible = true

func _on_main_weapon_item_cleared():
	sword.visible = false
func _on_body_armor_item_cleared():
	$Плечо2.texture = nude
	$Локоть2.texture = nude
	$Кисть21.texture = nude
	arm.texture = nude
	$ПраваяНога2.texture = nude
	$ПраваяНога1.texture = nude
	$ПраваяСтопа.texture = nude
	$ЛеваяНога2.texture = nude
	$ЛеваяНога1.texture = nude
	$ЛеваяСтопа.texture = nude
	$Тело.texture = nude
	$Плечо1.texture = nude
	$Кисть1.texture = nude
	$Локоть1.texture = nude
	skirt1.visible = false
	skirt2.visible = false
func _on_helmet_item_cleared():
	$Голова/Helmet.visible = false
	$Голова/Волосы4.visible = true
	$Голова/Волосы3.visible = true
	$Голова/Волосы2.visible = true
	$Голова/Волосы1.visible = true
func _on_gear_item_cleared():
	$Локоть1/Gear.visible = false
