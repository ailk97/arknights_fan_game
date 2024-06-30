extends CheckBox


var masha_standart = "res://.godot/imported/Маша.png-15bf62527e785c69bbc20af3203aaca5.ctex"


# Called when the node enters the scene tree for the first time.
func _process(delta):
	if button_pressed == true:
		$Маша/Body/Плечо2.texture = "МашаБроня.png"
		$Маша/Body/Локоть2.texture = "МашаБроня.png"
		$Маша/Body/Кисть21.texture = "МашаБроня.png"
		$Маша/Body/Кисть22.texture = "МашаБроня.png"
		$Маша/Body/ПраваяНога2.texture = "МашаБроня.png"
		$Маша/Body/ПраваяНога1.texture = "МашаБроня.png"
		$Маша/Body/ПраваяСтопа.texture = "МашаБроня.png"
		$Маша/Body/ЛеваяНога2.texture = "МашаБроня.png"
		$Маша/Body/ЛеваяНога1.texture = "МашаБроня.png"
		$Маша/Body/ЛеваяСтопа.texture = "МашаБроня.png"
		$Маша/Body/Тело.texture = "МашаБроня.png"
		$Маша/Body/Кисть1.texture = "МашаБроня.png"
		$Маша/Body/Локоть1.texture = "МашаБроня.png"
		$Маша/Body/Тело/Юбка2.visible = true
		$Маша/Body/Тело/Юбка1.visible = true

	if button_pressed == false:
		$Маша/Body/Плечо2.texture = masha_standart
		$Маша/Body/Локоть2.texture = "Маша.png"
		$Маша/Body/Кисть21.texture = "Маша.png"
		$Маша/Body/Кисть22.texture = "Маша.png"
		$Маша/Body/ПраваяНога2.texture = "Маша.png"
		$Маша/Body/ПраваяНога1.texture = "Маша.png"
		$Маша/Body/ПраваяСтопа.texture = "Маша.png"
		$Маша/Body/ЛеваяНога2.texture = "Маша.png"
		$Маша/Body/ЛеваяНога1.texture = "Маша.png"
		$Маша/Body/ЛеваяСтопа.texture = "Маша.png"
		$Маша/Body/Тело.texture = "Маша.png"
		$Маша/Body/Плечо1.texture = "Маша.png"
		$Маша/Body/Кисть1.texture = "Маша.png"
		$Маша/Body/Локоть1.texture = "Маша.png"
		$Маша/Body/Тело/Юбка2.visible = false
		$Маша/Body/Тело/Юбка1.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
