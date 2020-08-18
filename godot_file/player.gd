extends Area2D
signal fire

var screen_size : Vector2
export var speed := 400 
var bullet = preload("res://bullet.tscn")

func _ready() -> void:
	screen_size = get_viewport_rect().size


func _process(delta: float) -> void:
	var velocity = Vector2()
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
		$AnimatedSprite.set_animation('right')
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
		$AnimatedSprite.set_animation('left')
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
		$AnimatedSprite.set_animation('up')
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
		$AnimatedSprite.set_animation('down')
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	position += velocity * delta 
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	if Input.is_action_just_pressed("ui_fire"):
		emit_signal("fire")


func _on_player_fire() -> void:
	var temp : Node = bullet.instance()
	get_parent().add_child(temp)
	print(get_parent().collision_layer == get_parent().get_children()[0].collision_layer)
	if $AnimatedSprite.get_animation() == 'up':
		temp.position = Vector2(position.x,position.y - 64)
		temp.linear_velocity = Vector2(0,-700)
		temp.rotation_degrees = 0
	if $AnimatedSprite.get_animation() == 'down':
		temp.position = Vector2(position.x,position.y + 64)
		temp.linear_velocity = Vector2(0,700)
		temp.rotation_degrees = 180
	if $AnimatedSprite.get_animation() == 'left':
		temp.position = Vector2(position.x - 64,position.y)
		temp.linear_velocity = Vector2(-700,0)
		temp.rotation_degrees = 270
	if $AnimatedSprite.get_animation() == 'right':
		temp.position = Vector2(position.x + 64,position.y)
		temp.linear_velocity = Vector2(700,0)
		temp.rotation_degrees = 90




func _on_player_body_entered(body: Node) -> void:
	print("ok")
