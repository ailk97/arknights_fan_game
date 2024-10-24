extends CharacterBody2D

var health = 100
var enemy_name = "Дед Максим"
var speed = 120
var player = null
var chassing = false
var dying = false
var still_dying = false
var item_generated = false
var attacking = false
var is_attacking = false
var damage_enemy = 20
var playerInZone = false
var area1

var loot = ["UrsusArmor1", "Weapon1", "LightArmor1", "LightArmor2", "UrsusHelmet1"]

func drop_item():
	var item_drop1 = preload("res://Inventory/ProtoItems/dropped_item.tscn")
	var item_drop = item_drop1.instantiate()
	get_parent().add_child(item_drop)
	$InventoryGrid123.transfer($InventoryGrid123.get_item_at(Vector2i(0,0)), item_drop.get_node("InventoryGrid"))
	item_drop.apply_text()
	item_drop.position = global_position
func attack():
	is_attacking = true
	chassing = false
	$AnimationPlayer.current_animation = "Attack"
	$AnimationPlayer.speed_scale = 1.0
	await get_tree().create_timer(1).timeout
	if playerInZone == false:
		chassing = true
		is_attacking = false
	_on_damage_player_area_area_entered(area1)
	_on_damage_player_area_area_exited(area1)

func _process(_delta):
	$EnemyHealth.visible = health != 100
	
	#if health == 100:
		#$EnemyHealth.visible = false
	#else:
		#$EnemyHealth.visible = true
	$EnemyHealth/HealthBar.value = health
func _physics_process(_delta):
	if dying == false:
		if attacking == true:
			await attack()
		elif chassing == true and is_attacking == false:
			if velocity.x > 0:
				for turn_right2 in 12:
					if $Body.scale.x < 1.1:
						$Body.scale.x = $Body.scale.x + 0.2
						await get_tree().create_timer(0.001).timeout
						continue
					if $Body.scale.x == 1.2:
						break
			if velocity.x < 0:
				for turn_left2 in 12:
					if $Body.scale.x > -1.1:
						$Body.scale.x = $Body.scale.x + -0.2
						await get_tree().create_timer(0.001).timeout
						continue
					if $Body.scale.x == -1.2:
						break
			velocity = (player.position - position).normalized()
			velocity.y = velocity.y*0.8
			set_velocity(velocity * speed)
			move_and_slide()
			$AnimationPlayer.current_animation = "run"
			$AnimationPlayer.speed_scale = 2.0
			await get_tree().create_timer(0.5).timeout
		elif is_attacking == false:
			$AnimationPlayer.current_animation = "idle"
			$AnimationPlayer.speed_scale = 0.5

func _ready():
	
	#print(loot)
	#if $Hitbox.is_in_group("can_be_damaged"):
		#Events.connect("make_damage_player", health_update)
	#else:
		#Events.disconnect("make_damage_player", health_update)
	if item_generated == false:
		#randomize()
		#var random_item = randi_range(0, 4)
		#var item_ = ""
		#if random_item == 0:
			#item_ = "UrsusArmor1"
		#elif random_item == 1:
			#item_ = "Weapon1"
		#elif random_item == 2:
			#item_ = "LightArmor1"
		#elif random_item == 3:
			#item_ = "LightArmor2"
		#elif random_item == 4:
			#item_ = "UrsusHelmet1"
		var item_ = loot.pick_random()
		$InventoryGrid123.create_and_add_item(item_)
		item_generated = true

func set_percent(percentage: float) -> void:
	$Body.material.set_shader_parameter('percentage', percentage)

func tween_percent():
	var tween = get_tree().create_tween()
	tween.tween_method(set_percent, 1.0, 0.0, 1.0)

func can_be_damaged():
	if $Hitbox.is_in_group("can_be_damaged"):
		Events.connect("make_damage_player", health_update)
	else:
		Events.disconnect("make_damage_player", health_update)
func health_update(damage):
	if health <= 0:
		$Hitbox/CollisionShape2D.disabled = true
		$AnimationPlayer.current_animation = "death"
		$AnimationPlayer.speed_scale = 0.6
		var player_who_kill = player
		dying = true
		await get_tree().create_timer(1.0).timeout
		tween_percent()
		await get_tree().create_timer(1.0).timeout
		drop_item()
		Events.EnemyDeath("Enemy", player_who_kill)
		queue_free()
	else:
		$Body/GPUParticles2D.restart()
		health -= damage
		$Body/Body.use_parent_material = false
		$Body/GPUParticles2D.emitting = true
		await get_tree().create_timer(0.01).timeout
		$Body/Body.use_parent_material = true
		$Body/GPUParticles2D.emitting = false

func _on_attack_area_body_entered(body):
	if body.is_in_group("player"):
		attacking = true
func _on_attack_area_body_exited(body):
	if body.is_in_group("player"):
		attacking = false

func _on_see_area_body_entered(body):
	if body.is_in_group("player"):
		player = body
		chassing = true
func _on_see_area_body_exited(body):
	if body.is_in_group("player"):
		player = null
		chassing = false

func _on_damage_player_area_area_entered(area):
	area1 = area
	playerInZone = true
	if is_attacking == true:
		Events.emit_signal("make_damage_enemy", damage_enemy)
func _on_damage_player_area_area_exited(_area):
	playerInZone = false
	area1 = null
