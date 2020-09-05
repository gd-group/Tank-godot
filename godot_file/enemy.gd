extends KinematicBody2D
signal enemy_killed

class_name Enemy
var screen_size : Vector2
var velocity = Vector2()
var saved_pos
var enemy_dir = { \
	'up' : [Vector2(0,-1),'up'],\
	'down' : [Vector2(0,1),'down']}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size

func on_hit():
	emit_signal("enemy_killed")
	queue_free()



func _physics_process(delta: float) -> void:
	var dir = ['up','down'] #loop array
	var temp_dict = {'up' : true,'down' : true} #check for temp direction available
	var temp_ran = []
	$r_down.add_exception(RigidBody2D)
	$r_up.add_exception(RigidBody2D)
	if $r_up.is_colliding():
		temp_dict['up'] = false
	if $r_down.is_colliding():
		temp_dict['down'] = false
	var dir_ct = 0 
	for i in dir: #check for direction count ; if more than one direction is available, will proceed to randomize select
		if temp_dict[i] == true:
			dir_ct +=1
	if dir_ct == 1: #situation for only one direction is available, change velocity and animatedsprite for the available one
		for i in dir:
			if temp_dict[i] == true:
				print(i)
				velocity += enemy_dir[i][0]
				$AnimatedSprite.set_animation(enemy_dir[i][1])
				saved_pos = i
	if dir_ct == 2: # situation for two available direction, sometimes animation flickers
		for i in dir:
			if i == saved_pos:
				for g in range(15):
					temp_ran.append(i)
			else:
				temp_ran.append(i)
		var select = temp_ran[int(rand_range(0,len(temp_ran)))]
		velocity += enemy_dir[select][0]
		$AnimatedSprite.set_animation(enemy_dir[select][1])
		print('here')
		print(temp_dict)
		
	print(velocity)
		
	position += move_and_slide(velocity) * delta 
	position.x = clamp(position.x, 28, screen_size.x - 28)
	position.y = clamp(position.y, 28, screen_size.y - 28)
	
		
	
