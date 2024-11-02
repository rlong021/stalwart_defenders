extends CharacterBody2D

signal gob_near

@export var Damage = 25
var SPEED = 10
enum FIGHTER_STATE { PASSIVE, ACTIVE}
var active_state
var travel_to_passive
var travel_to_active
var closest_gob
@export var check_if_gob_still_near:int

func _ready() -> void:
	travel_to_passive = Vector2(0,0)
	check_if_gob_still_near = 0
	$Area2D2ForAttack.Damage = Damage
	$AnimatedSprite2D.play("idle")
	$Area2D2ForAttack/CollisionPolygon2D.disabled = true
	travel_to_passive = Vector2(0,0)
	pass # Replace with function body.

func _process(delta: float) -> void:
	var velocity = Vector2.ZERO

	if active_state == FIGHTER_STATE.ACTIVE  || travel_to_active != null:
		if travel_to_passive != Vector2(0,0):
			travel_to_passive = Vector2(0,0)
		if travel_to_active != null:
			velocity = (travel_to_active - position).normalized()
			if velocity.length() > 0:
				move_and_collide(velocity)
				velocity = velocity * SPEED
			position += velocity * SPEED * delta
			rotation = velocity.angle()+PI/2
			
	if travel_to_active != null && position.distance_to(travel_to_active) < 2:
		travel_to_active = null
 
	elif active_state == FIGHTER_STATE.PASSIVE:
		if travel_to_passive != Vector2(0,0) && travel_to_active == null:
			velocity = (travel_to_passive - position).normalized()
			if velocity.length() > 0:
				move_and_collide(velocity)
				if position.distance_to(travel_to_passive) > 2:
					velocity = velocity * SPEED
				else:
					velocity = velocity * SPEED /16
					#travel_to_passive = null
			position += velocity * SPEED * delta /4
			rotation = velocity.angle()+PI/2
		if check_if_gob_still_near == 0:
			travel_to_passive = Vector2(0,0)
		if check_if_gob_still_near == 0 && position.distance_to($"../FighterFlag".position)>2:
			travel_to_active = $"../FighterFlag".position
		elif check_if_gob_still_near > 0 && position.distance_to(travel_to_passive) <20:
			attack(true)

	move_and_slide()
		
func change_state(new_state):
	if new_state == "active":
		active_state = FIGHTER_STATE.ACTIVE
	else:
		active_state = FIGHTER_STATE.PASSIVE

func _input(event):
	if event.is_action_pressed("attack") && active_state == FIGHTER_STATE.ACTIVE:
		attack(true)
	if event.is_action_pressed("move_to") && active_state == FIGHTER_STATE.ACTIVE:
		moveto(event.position)

func attack(attacking):
	if attacking == true:
		$AnimatedSprite2D.play("attack")
		$Area2D2ForAttack/CollisionPolygon2D.disabled = false
	else:
		$Area2D2ForAttack/CollisionPolygon2D.disabled = true
		$AnimatedSprite2D.play("idle")
	pass
	
func moveto(placetomove):
	travel_to_active = placetomove
	#$Area2D.global_position = placetomove
	$"../FighterFlag".position = placetomove




func _on_animated_sprite_2d_animation_finished() -> void:
	attack(false)

func _on_fighter_flag_area_entered(area: Area2D) -> void:
	check_if_gob_still_near = 5
	gob_near.emit(check_if_gob_still_near)
	if closest_gob == null:
		closest_gob = area.global_position
	elif position.distance_to(area.global_position) < position.distance_to(closest_gob):
		closest_gob = area.global_position
	travel_to_passive = closest_gob

func _on_fighter_flag_closest_gob(sentVal, gobnear) -> void:
	closest_gob = sentVal
	check_if_gob_still_near = gobnear
