extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play("fighter")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_level_current_hero(CurHero) -> void:
	if CurHero == 0:
		$AnimatedSprite2D.play("fighter")
	elif CurHero == 1:
		$AnimatedSprite2D.play("archer")
	else:
		$AnimatedSprite2D.play("mage")


func _on_level_goblins_left(gobLeft) -> void:
	$gobleftnumber.text = str(gobLeft," x")
