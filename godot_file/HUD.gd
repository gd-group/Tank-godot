extends CanvasLayer




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
	
func init(life : int , enemy : int):
	$enemy_init.text = str(life)
	$life_init.text = str(enemy)
	$end.visible = false
	
func player_hit(life : int):
	life -= 1
	$life_init.text = str(life)
	return life

func enemy_k(enemy_total : int):
	enemy_total -= 1
	$enemy_init.text = str(enemy_total)
	return enemy_total


