extends RigidBody2D

var gob_HP:int
var gob_Max_HP:int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gob_Max_HP = 100
	gob_HP = gob_Max_HP
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if gob_HP < gob_Max_HP && $ProgressBar.visible == false:
		$ProgressBar.visible = true
	


func _on_area_2d_for_damage_area_entered(area: Area2D) -> void:
	print("getting hit")
	gob_HP += -area.damage
	if gob_HP <=0:
		kill_gob()
	$ProgressBar.value = gob_HP/gob_Max_HP

func kill_gob():
	$".".visible = false
	queue_free() 
