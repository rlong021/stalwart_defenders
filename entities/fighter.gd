extends CharacterBody2D

@export var Damage = 25
var SPEED = 10
enum FIGHTER_STATE { PASSIVE, ACTIVE}
var active_state
var travel_to

func _ready() -> void:
	$Area2D2ForAttack.Damage = Damage
	$AnimatedSprite2D.play("idle")
	$Area2D2ForAttack/CollisionPolygon2D.disabled = true
	travel_to = null
	pass # Replace with function body.

func _process(delta: float) -> void:
	var velocity = Vector2.ZERO

	if active_state == FIGHTER_STATE.ACTIVE:
		travel_to = null
		velocity = Input.get_vector("move_left","move_right","move_up","move_down").normalized()
		if velocity.length() > 0:
			move_and_collide(velocity)
			velocity = velocity * SPEED
		position += velocity * SPEED * delta

	elif active_state == FIGHTER_STATE.PASSIVE:
		if travel_to != null:
			velocity = (travel_to - position).normalized()
			if velocity.length() > 0:
				move_and_collide(velocity)
				velocity = velocity * SPEED
			position += velocity * SPEED * delta /4

	move_and_slide()
		
func change_state(new_state):
	if new_state == "active":
		active_state = FIGHTER_STATE.ACTIVE
	else:
		active_state = FIGHTER_STATE.PASSIVE

func _input(event):
	if event.is_action_pressed("attack") && active_state == FIGHTER_STATE.ACTIVE:
		attack(true)

func attack(attacking):
	if attacking == true:
		$AnimatedSprite2D.play("attack")
		$Area2D2ForAttack/CollisionPolygon2D.disabled = false
	#await get_tree().create_timer(0.3).timeout
	else:
		$Area2D2ForAttack/CollisionPolygon2D.disabled = true
		$AnimatedSprite2D.play("idle")
	pass

func _on_area_2d_area_entered(area: Area2D) -> void:
	travel_to = area.global_position
	pass


func _on_timer_detect_enemy_timeout() -> void:
	if $Area2D/CollisionFIndEnemy.disabled == true:
		$Area2D/CollisionFIndEnemy.disabled = false
	else:
		$Area2D/CollisionFIndEnemy.disabled = true


func _on_animated_sprite_2d_animation_finished() -> void:
	attack(false)
