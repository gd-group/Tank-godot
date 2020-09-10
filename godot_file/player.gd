extends KinematicBody2D
signal fire

var screen_size : Vector2
export var speed := 250
var bullet = preload("res://bullet.tscn")

func _ready() -> void:
	screen_size = get_viewport_rect().size


func _process(delta: float) -> void:
	var velocity = Vector2()
	if !(Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down")):
		position = Vector2(round(position.x/32)*32,round(position.y/32)*32)
	if Input.is_action_pressed("ui_right"): 
		velocity.x += 1
		$AnimatedSprite.set_animation('right')
		$CollisionShape2D.rotation_degrees = -90
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
		$AnimatedSprite.set_animation('left')
		$CollisionShape2D.rotation_degrees = 90
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
		$AnimatedSprite.set_animation('up')
		$CollisionShape2D.rotation_degrees = 0
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
		$AnimatedSprite.set_animation('down')
		$CollisionShape2D.rotation_degrees = 180
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	position += move_and_slide(velocity) * delta 
	position.x = clamp(position.x, 28, screen_size.x - 28)
	position.y = clamp(position.y, 28, screen_size.y - 28)
	if Input.is_action_just_pressed("ui_fire"):
		emit_signal("fire")


func _on_player_fire() -> void:
	var temp : Bullet = bullet.instance()
	get_parent().add_child(temp)
	temp.connect("bullet_hit",get_parent(),"hit_block")
	temp.set_collision_mask_bit(1, true)
	if $AnimatedSprite.get_animation() == 'up':
		temp.position = Vector2(position.x,position.y - 32)
		temp.linear_velocity = Vector2(0,-500)
		temp.rotation_degrees = 0
	if $AnimatedSprite.get_animation() == 'down':
		temp.position = Vector2(position.x,position.y + 32)
		temp.linear_velocity = Vector2(0,500)
		temp.rotation_degrees = 180
	if $AnimatedSprite.get_animation() == 'left':
		temp.position = Vector2(position.x - 32,position.y)
		temp.linear_velocity = Vector2(-500,0)
		temp.rotation_degrees = 270
	if $AnimatedSprite.get_animation() == 'right':
		temp.position = Vector2(position.x + 32,position.y)
		temp.linear_velocity = Vector2(500,0)
		temp.rotation_degrees = 90





