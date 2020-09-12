extends KinematicBody2D
signal enemy_killed

class_name Enemy
var screen_size : Vector2
var velocity = Vector2(0,70)
var cur_dir = 'down'
var dir_velocity = {
	'up' : Vector2(0,-70),
	'down' : Vector2(0,70),
	'right' : Vector2(70,0),
	'left' : Vector2(-70,0)
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	cur_dir = 'down'
	velocity = dir_velocity[cur_dir]

func on_hit():
	emit_signal("enemy_killed")
	queue_free()

func turn(dir: String):
	if dir == cur_dir:
		return
	velocity = dir_velocity[dir]
	position = Vector2(round(position.x/32)*32,round(position.y/32)*32)
	$AnimatedSprite.set_animation(dir)
	cur_dir = dir

func _physics_process(delta: float) -> void:
	#var dir = ['up','down','right','left'] #loop array
#	var temp_dict = {'up' : true,'down' : true, 'right' : true, 'left' : true} #check for temp direction available
#	var temp_ran = []
#	var dir_ct = 4
#	if $r_up.is_colliding() or $r_up2.is_colliding():
#		temp_dict['up'] = false
#		dir_ct -= 1
#	if $r_down.is_colliding() or $r_down2.is_colliding():
#		temp_dict['down'] = false
#		dir_ct -= 1
#	if $r_right.is_colliding() or $r_right2.is_colliding():
#		temp_dict['right'] = false
#		dir_ct -= 1
#	if $r_left.is_colliding() or $r_left2.is_colliding():
#		temp_dict['left'] = false
#		dir_ct -= 1
#	for i in temp_dict: #check for direction count ; if more than one direction is available, will proceed to randomize select
#		if temp_dict[i] == true:
#			dir_ct +=1
#	if dir_ct == 1: #situation for only one direction is available, change velocity and animatedsprite for the available one
#		for i in temp_dict:
#			if temp_dict[i] == true:
#				velocity = dir_velocity[i][0]
#				$AnimatedSprite.set_animation(dir_velocity[i][1])
#				cur_dir = i
#	if dir_ct == 2: # situation for two available direction, it waits for the velocity to change to Zero
#		for i in temp_dict:
#			if i == cur_dir:
#				for _g in range(250): #weight of current direction; but it changes a lot so please check here....
#					temp_ran.append(i)
#			else:
#				if temp_dict[i] == true:
#					temp_ran.append(i)
#		var select = temp_ran[int(rand_range(0,len(temp_ran)))]
#		if select != cur_dir:
#			position = Vector2(round(position.x/32)*32,round(position.y/32)*32)
#		velocity = dir_velocity[select][0]
#		$AnimatedSprite.set_animation(dir_velocity[select][1])
#		cur_dir = select
#	if dir_ct == 3: # situation for three available direction
#		for i in dir:
#			if i == cur_dir:
#				for _g in range(250): #weight of current direction
#					temp_ran.append(i)
#			else:
#				if temp_dict[i] == true:
#					temp_ran.append(i)
#		var select = temp_ran[int(rand_range(0,len(temp_ran)))]
#		if select != cur_dir:
#			position = Vector2(round(position.x/32)*32,round(position.y/32)*32)
#		velocity = dir_velocity[select][0]
#		$AnimatedSprite.set_animation(dir_velocity[select][1])
#		cur_dir = select
#	if dir_ct == 4: # situation for three available direction
#		for i in dir:
#			if i == cur_dir:
#				for _g in range(250): #weight of current direction
#					temp_ran.append(i)
#			else:
#				if temp_dict[i] == true:
#					temp_ran.append(i)
#		var select = temp_ran[int(rand_range(0,len(temp_ran)))]
#		if select != cur_dir:
#			position = Vector2(round(position.x/32)*32,round(position.y/32)*32)
#		velocity = dir_velocity[select][0]
#		$AnimatedSprite.set_animation(dir_velocity[select][1])
#		cur_dir = select
	var avail_dirs = []		# available direction
	var weights = []		# weight of available direction
	var total_weight = 0.0	# total weight
	if not($r_up.is_colliding() or $r_up2.is_colliding()):
		avail_dirs.append('up')
	if not($r_down.is_colliding() or $r_down2.is_colliding()):
		avail_dirs.append('down')
	if not($r_right.is_colliding() or $r_right2.is_colliding()):
		avail_dirs.append('right')
	if not($r_left.is_colliding() or $r_left2.is_colliding()):
		avail_dirs.append('left')
	# calculate accumlated weights of each available direction
	for i in avail_dirs:
		# if current direction available, give 250 weight, other 1
		total_weight += (250 if i == cur_dir else 1)
		weights.append(total_weight)
	# random a weight which between 0 and total_weight
	var ran_weight = randf() * total_weight
	for i in range(len(weights)):
		if ran_weight < weights[i]:
			self.turn(avail_dirs[i])
			break

	position += move_and_slide(velocity) * delta 
	position.x = clamp(position.x, 28, screen_size.x - 28)
	position.y = clamp(position.y, 28, screen_size.y - 28)
	
		
	
