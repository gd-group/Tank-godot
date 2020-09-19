extends RigidBody2D
signal bullet_hit(ancL, ancR)
class_name Bullet

func _ready() -> void:
	pass 


func _on_bullet_body_entered(body: Node) -> void:
	if body is Enemy:
		body.on_hit()
	elif body is KinematicBody2D :
		body.on_hit()
		
	emit_signal("bullet_hit",$AncL.get_global_position(),$AncR.get_global_position())
	queue_free()
	


func _on_VisibilityNotifier2D_viewport_exited(viewport: Viewport) -> void:
	queue_free()
