extends CharacterBody2D

var health = 100
var enemy_name = "Shopper"
var speed = 120
var player = null
var chassing = false
var dying = false
var type = "dialog"

func _process(_delta):
	if health == 100:
		$EnemyHealth.visible = false
	else:
		$EnemyHealth.visible = true
	$EnemyHealth/HealthBar.value = health

func _physics_process(_delta):
	$AnimationPlayer.current_animation = "idle"
	$AnimationPlayer.speed_scale = 0.5

#func _ready():
	#Events.connect("make_damage_player", health_update)
#
#func health_update(damage):
	#health -= damage

func _on_see_area_body_entered(body):
	if body.is_in_group("player"):
		player = body

func _on_see_area_body_exited(body):
	if body.is_in_group("player"):
		player = null
