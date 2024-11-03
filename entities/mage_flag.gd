extends Area2D

signal closest_gob

var check_if_gob_still_near

func _ready() -> void:
	check_if_gob_still_near = 0

func _process(delta: float) -> void:
	pass

func _on_timer_detect_enemy_timeout() -> void:
	if check_if_gob_still_near != 0:
		check_if_gob_still_near += -1
	closest_gob.emit(null,check_if_gob_still_near)
	if $CollisionFIndEnemy.disabled == true:
		$CollisionFIndEnemy.disabled = false
	else:
		$CollisionFIndEnemy.disabled = true

func _on_mage_gob_near(sentVal) -> void:
	check_if_gob_still_near = sentVal
