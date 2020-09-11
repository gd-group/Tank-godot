extends KinematicBody2D
signal enemy_killed

class_name Enemy
var screen_size : Vector2
var velocity = Vector2()
var saved_pos
var enemy_dir = { \
	'up' : [Vector2(0,-70),'up'],\
	'down' : [Vector2(0,70),'down'],\
	'right' : [Vector2(70,0),'right'],\
	'left' : [Vector2(-70,0),'left']}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size

func on_hit():
	emit_signal("enemy_killed")
	queue_free()



func _physics_process(delta: float) -> void:
	var dir = ['up','down','right','left'] #loop array
	var temp_dict = {'up' : true,'down' : true, 'right' : true, 'left' : true} #check for temp direction available
	var temp_ran = []
	if $r_up.is_colliding() or $r_up2.is_colliding():
		temp_dict['up'] = false
	if $r_down.is_colliding() or $r_down2.is_colliding():
		temp_dict['down'] = false
	if $r_right.is_colliding() or $r_right2.is_colliding():
		temp_dict['right'] = false
	if $r_left.is_colliding() or $r_left2.is_colliding():
		temp_dict['left'] = false
	var dir_ct = 0 
	for i in dir: #check for direction count ; if more than one direction is available, will proceed to randomize select
		if temp_dict[i] == true:
			dir_ct +=1
	if dir_ct == 1: #situation for only one direction is available, change velocity and animatedsprite for the available one
		for i in dir:
			if temp_dict[i] == true:
				velocity = enemy_dir[i][0]
				$AnimatedSprite.set_animation(enemy_dir[i][1])
				saved_pos = i
	if dir_ct == 2: # situation for two available direction, it waits for the velocity to change to Zero
		for i in dir:
			if i == saved_pos:
				for _g in range(250): #weight of current direction; but it changes a lot so please check here....
					temp_ran.append(i)
			else:
				if temp_dict[i] == true:
					temp_ran.append(i)
		var select = temp_ran[int(rand_range(0,len(temp_ran)))]
		if select != saved_pos:
			position = Vector2(round(position.x/32)*32,round(position.y/32)*32)
		velocity = enemy_dir[select][0]
		$AnimatedSprite.set_animation(enemy_dir[select][1])
		saved_pos = select
	if dir_ct == 3: # situation for three available direction
		for i in dir:
			if i == saved_pos:
				for _g in range(250): #weight of current direction
					temp_ran.append(i)
			else:
				if temp_dict[i] == true:
					temp_ran.append(i)
		var select = temp_ran[int(rand_range(0,len(temp_ran)))]
		if select != saved_pos:
			position = Vector2(round(position.x/32)*32,round(position.y/32)*32)
		velocity = enemy_dir[select][0]
		$AnimatedSprite.set_animation(enemy_dir[select][1])
		saved_pos = select
	if dir_ct == 4: # situation for three available direction
		for i in dir:
			if i == saved_pos:
				for _g in range(250): #weight of current direction
					temp_ran.append(i)
			else:
				if temp_dict[i] == true:
					temp_ran.append(i)
		var select = temp_ran[int(rand_range(0,len(temp_ran)))]
		if select != saved_pos:
			position = Vector2(round(position.x/32)*32,round(position.y/32)*32)
		velocity = enemy_dir[select][0]
		$AnimatedSprite.set_animation(enemy_dir[select][1])
		saved_pos = select

	position += move_and_slide(velocity) * delta 
	position.x = clamp(position.x, 28, screen_size.x - 28)
	position.y = clamp(position.y, 28, screen_size.y - 28)
	
		
	
