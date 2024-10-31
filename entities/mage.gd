extends CharacterBody2D

var SPEED = 10
enum MAGE_STATE { PASSIVE, ACTIVE}
var active_state

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	var velocity = Vector2.ZERO

	if active_state == MAGE_STATE.ACTIVE:
		velocity = Input.get_vector("move_left","move_right","move_up","move_down").normalized()
		if velocity.length() > 0:
			move_and_collide(velocity)
			velocity = velocity * SPEED
		position += velocity * SPEED * delta

	elif active_state == MAGE_STATE.PASSIVE:
		velocity = Vector2(0,0)
		if velocity.length() > 0:
			move_and_collide(velocity)
			velocity = velocity * SPEED
		position += velocity * SPEED * delta /4

	move_and_slide()

func change_state(new_state):
	if new_state == "active":
		active_state = MAGE_STATE.ACTIVE
	else:
		active_state = MAGE_STATE.PASSIVE
