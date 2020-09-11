extends TileMap
var contact_brick_pos = []
var enemy = preload("res://enemy.tscn")
var bullet = preload("res://bullet.tscn")
var enemy_fire_time = [0.5,3]
var enemy_total = 3
var init = true


func _ready() -> void:
	$enemy_fire_timer.start(rand_range(enemy_fire_time[0],enemy_fire_time[1]))
	$enemy_spawn_timer.start(1)
	
func hit_block(ancL, ancR):
	contact_brick_pos.append(world_to_map(ancL))
	contact_brick_pos.append(world_to_map(ancR))
	print(contact_brick_pos)
	for i in range(len(contact_brick_pos)):
		print(get_cellv(contact_brick_pos[i]))
		if get_cellv(contact_brick_pos[i]) == 0:
			set_cellv(contact_brick_pos[i],-1)

	contact_brick_pos.clear()



func _on_enemy_spawn_timer_timeout() -> void:
	var ran = [$spawn_point.position,$spawn_point2.position,$spawn_point3.position]
	var count = get_tree().get_nodes_in_group('enemy')
	if init == true:
		for _i in range(enemy_total - len(count)):
			var temp_enemy : Node = enemy.instance()
			get_parent().add_child(temp_enemy)
			temp_enemy.position = ran[_i]
			temp_enemy.connect("enemy_killed",self,"enemy_respawn")
	else:
		for _i in range(enemy_total - len(count)):
			var temp_enemy : Node = enemy.instance()
			get_parent().add_child(temp_enemy)
			temp_enemy.position = ran[int(rand_range(0,len(ran)))]
			temp_enemy.connect("enemy_killed",self,"enemy_respawn")
	$enemy_spawn_timer.stop()

func enemy_respawn():
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
		if target.get_node("AnimatedSprite").get_animation() == 'up':
			temp_bullet.position = Vector2(position.x,position.y - 64)
			temp_bullet.linear_velocity = Vector2(0,-500)
			temp_bullet.rotation_degrees = 0
		if target.get_node("AnimatedSprite").get_animation() == 'down':
			temp_bullet.position = Vector2(position.x,position.y + 64)
			temp_bullet.linear_velocity = Vector2(0,500)
			temp_bullet.rotation_degrees = 180
		if target.get_node("AnimatedSprite").get_animation() == 'left':
			temp_bullet.position = Vector2(position.x - 64,position.y)
			temp_bullet.linear_velocity = Vector2(-500,0)
			temp_bullet.rotation_degrees = 270
		if target.get_node("AnimatedSprite").get_animation() == 'right':
			temp_bullet.position = Vector2(position.x + 64,position.y)
			temp_bullet.linear_velocity = Vector2(500,0)
			temp_bullet.rotation_degrees = 90
		$enemy_fire_timer.start(rand_range(enemy_fire_time[0],enemy_fire_time[1]))

	
