extends TextureButton

var Name = "Усиленный удар"
var id = "Attack2"
var type = "Str"
var Description = "Усиленная базовая атака
Урон: х1.5"
var TimeActive = 0.5
var can_activate = true
var locker = true

func AbilityUse(Character):
	if not Character.get_node("ui/InventoryPanel/Panel/Equipment/MainWeapon2").get_item_at(Vector2i(0,0)) == null:
		Character.turn_character_x()
		Character.find_child("AnimationPlayer").current_animation = "Attack2"
		Character.find_child("AnimationPlayer").speed_scale = 2.0*Character.speed_action
		await Character.get_tree().create_timer(0.3/Character.speed_action).timeout
		if Character.in_distance == true:
			Character.damage *= 1.5
			Events.emit_signal("make_damage_player", Character.damage)
			print("Игрок наносит - ", Character.damage)
			Character.damage /= 1.5
		await Character.get_tree().create_timer(0.2/Character.speed_action).timeout
