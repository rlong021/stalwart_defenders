extends CharacterBody2D

var gob_HP:int
var gob_Max_HP:int

@export var SPEED = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gob_Max_HP = 100
	gob_HP = gob_Max_HP

func _process(delta: float) -> void:
	if gob_HP < gob_Max_HP && $ProgressBar.visible == false:
		$ProgressBar.visible = true
	
	velocity = velocity.normalized()
	if velocity.length() > 0:
		move_and_collide(velocity)
		velocity = velocity * SPEED
		position += velocity * SPEED * delta
	
	move_and_slide()

func kill_gob():
	$".".visible = false
	queue_free()

func _on_area_2_dfor_damage_area_entered(area: Area2D) -> void:
	#print("getting hit")
	gob_HP += -area.Damage
	#print("gob_HP: ",gob_HP)
	#print("gob_Max_HP: ",gob_Max_HP)
	#print((100*gob_HP/gob_Max_HP))
	if gob_HP <=0:
		kill_gob()
	$ProgressBar.value = (100*gob_HP/gob_Max_HP)
