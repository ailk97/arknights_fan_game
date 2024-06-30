extends TextureButton

var Name = "Прыжок"
var id = "Dash1"
var type = "Agi"
var Description = "Выпад в сторону, куда вы смотрите."
var TimeActive = 0.6
var can_activate = true
#var Character = owner

func AbilityUse(Character):
	Character.find_child("AnimationPlayer").current_animation = "dash1"
	Character.find_child("AnimationPlayer").speed_scale = 2.5/Character.speed_action
	Character.direction = Character.get_local_mouse_position().normalized()
	Character.turn_character_x()
	Character.velocity = Vector2(Character.dash_speed_x * Character.direction.x, Character.dash_speed_y * Character.direction.y)
	Character.set_velocity(Character.velocity)
	for aboba in 35*Character.speed_action:
		Character.move_and_slide()
		await Character.get_tree().create_timer(0.01/Character.speed_action).timeout
	#await get_tree().create_timer(0.5).timeout # waits for 1 second
