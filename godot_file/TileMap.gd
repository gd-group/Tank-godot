extends TileMap
var contact_brick_pos = []
var enemy = preload("res://enemy.tscn")
var bullet = preload("res://bullet.tscn")
var enemy_fire_time = [0.25,1]
var enemy_total_per = 3
var enemy_total = 5
var init = true
var life = 3
var state = true

func _ready() -> void:
	randomize()
	state = true
	restart()
	
func restart():
	$enemy_fire_timer.start(rand_range(enemy_fire_time[0],enemy_fire_time[1]))
	$enemy_spawn_timer.start(1)
	enemy_total = 5
	life = 3
	$HUD.init(enemy_total,life)
	$player.show()

func _process(delta: float) -> void:
	#if state == false and Input.is_action_just_released("ui_accept"):
		#restart()
	pass

func game_over():
	$HUD/end.visible = true
	$player.hide()
	get_tree().call_group("enemy", "queue_free")
	yield(get_tree().create_timer(3), "timeout")
	state = false
	
func hit_block(ancL, ancR):
	contact_brick_pos.append(world_to_map(ancL))
	contact_brick_pos.append(world_to_map(ancR))
	#print(contact_brick_pos)
	for i in range(len(contact_brick_pos)):
		#print(get_cellv(contact_brick_pos[i]))
		if get_cellv(contact_brick_pos[i]) == 0:
			set_cellv(contact_brick_pos[i],-1)

	contact_brick_pos.clear()



func _on_enemy_spawn_timer_timeout() -> void:
	var ran = [$spawn_point.position,$spawn_point2.position,$spawn_point3.position]
	var count = get_tree().get_nodes_in_group('enemy')
	if init == true:
		for _i in range(enemy_total_per - len(count)):
			var temp_enemy : Enemy = enemy.instance()
			get_parent().add_child(temp_enemy)
			temp_enemy.position = ran[_i]
			temp_enemy.connect("enemy_killed",self,"enemy_respawn")
	else:
		ran.shuffle()
		for _i in range(clamp(enemy_total_per - len(count),0,enemy_total)):
			var temp_enemy : Enemy = enemy.instance()
			get_parent().add_child(temp_enemy)
			temp_enemy.position = ran[_i]
			temp_enemy.connect("enemy_killed",self,"enemy_respawn")
	$enemy_spawn_timer.stop()

func enemy_respawn():
	enemy_total = $HUD.enemy_k(enemy_total)
	if enemy_total <= 0:
		game_over()
	else:
		$enemy_spawn_timer.start(5)
		init = false
	
	

func _on_enemy_fire_timer_timeout() -> void:
	if len(get_tree().get_nodes_in_group("enemy")) > 0:
		var gp = get_tree().get_nodes_in_group("enemy")
		var target = gp[rand_range(0,len(gp))]
		var temp_bullet = bullet.instance()
		temp_bullet.connect("bullet_hit",self,"hit_block")
		target.add_child(temp_bullet)
		temp_bullet.position = target.position
		temp_bullet.set_collision_mask_bit(0, true)
		if target.get_node("AnimatedSprite").get_animation() == 'up':
			temp_bullet.position = Vector2(position.x,position.y - 34)
			temp_bullet.linear_velocity = Vector2(0,-500)
			temp_bullet.rotation_degrees = 0
		if target.get_node("AnimatedSprite").get_animation() == 'down':
			temp_bullet.position = Vector2(position.x,position.y + 34)
			temp_bullet.linear_velocity = Vector2(0,500)
			temp_bullet.rotation_degrees = 180
		if target.get_node("AnimatedSprite").get_animation() == 'left':
			temp_bullet.position = Vector2(position.x - 34,position.y)
			temp_bullet.linear_velocity = Vector2(-500,0)
			temp_bullet.rotation_degrees = 270
		if target.get_node("AnimatedSprite").get_animation() == 'right':
			temp_bullet.position = Vector2(position.x + 34,position.y)
			temp_bullet.linear_velocity = Vector2(500,0)
			temp_bullet.rotation_degrees = 90
		$enemy_fire_timer.start(rand_range(enemy_fire_time[0],enemy_fire_time[1]))

	


func _on_player_hit_by() -> void:
	life = $HUD.player_hit(life)
	if life == 0:
		game_over()
		$player.queue_free()
