extends TextureButton

@export var Skill_Before = TextureButton
@export var Character = CharacterBody2D
@export var Ability_Path = ""

func _on_pressed():
	print(Ability_Path)
	if Skill_Before.disabled == false and Character.points >= 1:
		unlock()
		Character.points -= 1

func unlock():
	get_parent().disabled = false
	disabled = false
	visible = false
	Character.unlockedAbilitys.append(Ability_Path)
	print(Character.unlockedAbilitys)
