extends Node2D

@export var mageSpellExplosion : PackedScene

@export var speed = 600
@export var direction:Vector2
@export var Damage:int
var explosionDamage

func _ready():
	explosionDamage = Damage
	Damage = 0
	$AnimatedSprite2D2shot.play("shot")

func _process(delta):
	position += direction * delta * speed

func _on_die_timer_timeout() -> void:
	blow_up()

func _on_area_entered(area: Area2D) -> void:
	blow_up()

func blow_up():
	var new_spell_Explosion = mageSpellExplosion.instantiate()
	new_spell_Explosion.Damage = explosionDamage
	new_spell_Explosion.position = global_position
	add_sibling(new_spell_Explosion)
	
	hide()
	queue_free()
