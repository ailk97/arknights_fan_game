extends Control

var AbilityName = ""
var AbilityDesc = ""
var AbilitySelected
var AbilityActive1
var AbilityActive2

func _process(_delta):
	if not AbilitySelected == null:
		if AbilitySelected.button_pressed == true and Input.is_action_just_pressed("ability1"):
			await get_tree().create_timer(0.1).timeout
			get_parent().get_parent().get_node("Equip").play()
			ability1()
		elif AbilitySelected.button_pressed == true and Input.is_action_just_pressed("ability2"):
			await get_tree().create_timer(0.1).timeout
			get_parent().get_parent().get_node("Equip").play()
			ability2()

func ability1():
	$Panel/Active1.texture_normal = AbilitySelected.texture_normal
	$Panel/Active1.disabled = false
	get_parent().get_node("Hud/TextureRect/Ability1").texture = AbilitySelected.texture_normal
	get_parent().get_node("Hud/TextureRect/Ability1/TextureProgressBar").visible = false
	AbilityActive1 = AbilitySelected
	print(AbilityActive1)
func ability2():
	$Panel/Active2.texture_normal = AbilitySelected.texture_normal
	$Panel/Active2.disabled = false
	get_parent().get_node("Hud/TextureRect/Ability2").texture = AbilitySelected.texture_normal
	get_parent().get_node("Hud/TextureRect/Ability2/TextureProgressBar").visible = false
	AbilityActive2 = AbilitySelected
	print(AbilityActive2)

func Selected():
	AbilityName = AbilitySelected.Name
	$Panel/Description/AbilityName.text = AbilityName
	AbilityDesc = AbilitySelected.Description
	$Panel/Description/AbilityDesc.text = AbilityDesc

func _on_dash_1_mouse_entered():
	AbilitySelected = $Panel/Agi/Dash1
	Selected()
func _on_dash_1_mouse_exited():
	$Panel/Description/AbilityName.text = ""
	$Panel/Description/AbilityDesc.text = ""

func _on_attack_1_mouse_entered():
	mouseEnter($Panel/Str/Attack1)
func _on_attack_1_mouse_exited():
	mouseExit()

func _on_attack_2_mouse_entered():
	mouseEnter($Panel/Str/Attack2)
func _on_attack_2_mouse_exited():
	mouseExit()

func _on_attack_3_mouse_entered():
	mouseEnter($Panel/Str/Attack3)
func _on_attack_3_mouse_exited():
	mouseExit()

func mouseEnter(selection):
	AbilitySelected = selection
	Selected()
func mouseExit():
	$Panel/Description/AbilityName.text = ""
	$Panel/Description/AbilityDesc.text = ""

func _on_active_1_pressed():
	if not $Panel/Active1.texture_normal == null:
		$Panel/Active1.texture_normal = null
		$Panel/Active1.disabled = true
		AbilityActive1 = null
func _on_active_2_pressed():
	if not $Panel/Active2.texture_normal == null:
		$Panel/Active2.texture_normal = null
		$Panel/Active2.disabled = true
		AbilityActive2 = null
