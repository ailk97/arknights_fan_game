extends Panel


# Called when the node enters the scene tree for the first time.
func _ready():
	if FileAccess.file_exists("user://Save/Save3/СharData.res"):
		var char = load("user://Save/Save3/СharData.res")
		$VBoxContainer/SaveName.text = str(char["SaveName"])
		$VBoxContainer/Lvl.text = "Уровень - " + str(char["Lvl"])
		$VBoxContainer/Exp.text = "Опыт - " + str(char["Exp"])
		$VBoxContainer/Str.text = "Сила - " + str(char["Str"])
		$VBoxContainer/Agi.text = "Ловкость - " + str(char["Agi"])
		$VBoxContainer/Int.text = "Интелект - " + str(char["Int"])
		$VBoxContainer/Money.text = "Деньги - " + str(char["Chervonets"])
		$Load3.disabled = false
	else:
		$VBoxContainer/SaveName.text = "*Третье сохранение*"
		$VBoxContainer/Lvl.text = "Уровень - *"
		$VBoxContainer/Exp.text = "Опыт - *"
		$VBoxContainer/Str.text = "Сила - *"
		$VBoxContainer/Agi.text = "Ловкость - *"
		$VBoxContainer/Int.text = "Интелект - *"
		$VBoxContainer/Money.text = "Деньги - *"
		$Load3.disabled = true
