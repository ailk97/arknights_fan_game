extends Node2D

var damage_enemy = 50

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$AnimationPlayer.current_animation = "damagetest_animation"
	$AnimationPlayer.speed_scale = 2

func _on_area_2d_area_entered(_area):
	Events.emit_signal("make_damage_enemy", damage_enemy)
