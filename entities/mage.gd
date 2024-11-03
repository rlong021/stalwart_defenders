extends CharacterBody2D

@export var mageSpell : PackedScene

signal gob_near

@export var Damage = 25
var SPEED = 10
enum MAGE_STATE { PASSIVE, ACTIVE}
var active_state
var travel_to_passive
var travel_to_active
var closest_gob
@export var check_if_gob_still_near:int
var lastlook
var spellRdy:bool

func _ready() -> void:
	spellRdy = true
	lastlook = Vector2(0,1)
	travel_to_passive = Vector2(0,0)
	check_if_gob_still_near = 0
	$AnimatedSprite2D.play("idle")
	$ShootTimer.wait_time = 0.5

func _process(delta: float) -> void:
	var velocity = Vector2.ZERO

	if active_state == MAGE_STATE.ACTIVE  || travel_to_active != null:
		if travel_to_active != null:
			velocity = (travel_to_active - position).normalized()
			lastlook = velocity
			if velocity.length() > 0:
				move_and_collide(velocity)
				velocity = velocity * SPEED
			position += velocity * SPEED * delta
			rotation = velocity.angle()+PI/2
			
	if travel_to_active != null && position.distance_to(travel_to_active) < 2:
		travel_to_active = null
 
	elif active_state == MAGE_STATE.PASSIVE || travel_to_active == null:
		if travel_to_passive != Vector2(0,0) && travel_to_active == null:
			velocity = (travel_to_passive - position).normalized()
			lastlook = velocity
			rotation = velocity.angle()+PI/2
		if check_if_gob_still_near == 0:
			travel_to_passive = Vector2(0,0)
		if check_if_gob_still_near == 0 && position.distance_to($"../MageFlag".position)>2:
			travel_to_active = $"../MageFlag".position
		elif check_if_gob_still_near > 0: # && position.distance_to(travel_to_passive) <10:
			attack(true)

	move_and_slide()
		
func change_state(new_state):
	if new_state == "active":
		active_state = MAGE_STATE.ACTIVE
	else:
		active_state = MAGE_STATE.PASSIVE

func _input(event):
	if event.is_action_pressed("attack") && active_state == MAGE_STATE.ACTIVE:
		attack(true)
	if event.is_action_pressed("move_to") && active_state == MAGE_STATE.ACTIVE:
		moveto(event.position)

func attack(attacking):
	if attacking == true && spellRdy == true:
		$AnimatedSprite2D.play("attack")
		var new_spell = mageSpell.instantiate()
		new_spell.rotation = (travel_to_passive - $Marker2D.global_position).angle()+PI/2
		new_spell.Damage = Damage
		new_spell.position = $Marker2D.global_position
		new_spell.direction = (travel_to_passive - $Marker2D.global_position).normalized()
		add_sibling(new_spell)
		spellRdy = false
		$ShootTimer.start()
	else:
		$AnimatedSprite2D.play("idle")
	
func moveto(placetomove):
	travel_to_active = placetomove
	$"../MageFlag".position = placetomove

func _on_animated_sprite_2d_animation_finished() -> void:
	attack(false)

func _on_mage_flag_area_entered(area: Area2D) -> void:
	check_if_gob_still_near = 5
	gob_near.emit(check_if_gob_still_near)
	if closest_gob == null:
		closest_gob = area.global_position
	elif position.distance_to(area.global_position) < position.distance_to(closest_gob):
		closest_gob = area.global_position
	travel_to_passive = closest_gob

func _on_mage_flag_closest_gob(sentVal, gobnear) -> void:
	closest_gob = sentVal
	check_if_gob_still_near = gobnear

func _on_shoot_timer_timeout() -> void:
	spellRdy = true
