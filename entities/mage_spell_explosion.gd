extends Area2D

@export var Damage:int

func _ready() -> void:
	$AnimatedSprite2Dexplosion.play("explosion")

func _process(delta: float) -> void:
	pass

func _on_animated_sprite_2_dexplosion_animation_finished() -> void:
	hide()
	queue_free()
