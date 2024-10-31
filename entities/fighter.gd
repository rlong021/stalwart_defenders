extends CharacterBody2D

var SPEED = 10
enum FIGHTER_STATE { PASSIVE, ACTIVE}
var active_state
var travel_to

func _ready() -> void:
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


func _on_area_2d_area_entered(area: Area2D) -> void:
	travel_to = area.global_position
	print(area.global_position)
	pass


func _on_timer_detect_enemy_timeout() -> void:
	if $Area2D/CollisionFIndEnemy.disabled == true:
		$Area2D/CollisionFIndEnemy.disabled = false
	else:
		$Area2D/CollisionFIndEnemy.disabled = true
