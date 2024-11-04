extends CharacterBody2D

var gob_HP:int
var gob_Max_HP:int
var gobattackRdy:bool
var closest_struc
var travel_to_passive
var Brid
var check_if_gob_still_near:int
var destroyed_struc
@export var SPEED = 10
var restart_closest = [6,299,600]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	destroyed_struc = ["0"]
	travel_to_passive = Vector2(0,0)
	Brid = null
	closest_struc = Vector2(restart_closest.pick_random(),444)
	gobattackRdy = true
	gob_Max_HP = 100
	gob_HP = gob_Max_HP

func _process(delta: float) -> void:
	if gob_HP < gob_Max_HP && $ProgressBar.visible == false:
		$ProgressBar.visible = true
	
	

	if travel_to_passive != Vector2(0,0):
		#print(travel_to_passive)
		#print(velocity)
		velocity = (travel_to_passive - global_position).normalized()
		if velocity.length() > 0:
			move_and_collide(velocity)
			if global_position.distance_to(travel_to_passive) > 2:
				velocity = velocity * SPEED
		position += velocity * SPEED * delta
		$AnimatedSprite2D.rotation = velocity.angle()+PI/2
	#if check_if_gob_still_near == 0:
		#travel_to_passive = Vector2(0,0)
	
	
	if check_if_gob_still_near > 0 && global_position.distance_to(travel_to_passive) <25 && Brid != null:
		attack(true,Brid)
	move_and_slide()

func kill_gob():
	$".".visible = false
	$"..".goblins_to_kill += -1
	queue_free()

func _on_area_2_dfor_damage_area_entered(area: Area2D) -> void:
	if area.Damage != null:
		print(area.name)
		gob_HP += -area.Damage
	if gob_HP <=0:
		kill_gob()
	$ProgressBar.value = (100*gob_HP/gob_Max_HP)

func _on_area_2_dfind_structure_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	check_if_gob_still_near = 5
	var tilecord = $"../TileMapLayer2".get_coords_for_body_rid(body_rid)
	var tileLoc = $"../TileMapLayer2".allcells.find(tilecord)
	var  newclosest_struc = $"../TileMapLayer2".map_to_local(tilecord)

	if closest_struc == null:
		closest_struc = newclosest_struc
		Brid = body_rid

	if global_position.distance_to(closest_struc)<1:
		closest_struc = Vector2(restart_closest.pick_random(),444)

	if global_position.distance_to(newclosest_struc) < global_position.distance_to(closest_struc) && destroyed_struc.find(body_rid) == -1:
		closest_struc = newclosest_struc
		Brid = body_rid
	else:
		travel_to_passive = Vector2.ZERO
	travel_to_passive = closest_struc
	
	

func attack(attacking,body_rid):
	#print("trying to attack")
	if attacking == true && gobattackRdy == true:
		$AnimatedSprite2D.play("attack")
		var tilecord = $"../TileMapLayer2".get_coords_for_body_rid(body_rid)
		var tileLoc = $"../TileMapLayer2".allcells.find(tilecord)
		if $"../TileMapLayer2".tilearray[tileLoc] > 0:
			$"../TileMapLayer2".tilearray[tileLoc] += -1
			$"../TileMapLayer2".took_damage(tilecord)
		if $"../TileMapLayer2".tilearray[tileLoc] == 0:
			$"../TileMapLayer2".erase_cell(tilecord)
			destroyed_struc.append(Brid)
			Brid = null
			closest_struc = Vector2(restart_closest.pick_random(),444)
			#$"../TileMapLayer2".fix_invalid_tiles()
		#print($"../TileMapLayer2".tilearray[tileLoc])
		$Area2DdamageStructure/CollisionShape2D.disabled = false
		gobattackRdy = false
		$AttackTimer.start()
		#Brid = null
	else:
		$Area2DdamageStructure/CollisionShape2D.disabled = true
		$AnimatedSprite2D.play("idle")
	pass

func _on_animated_sprite_2d_animation_finished() -> void:
	attack(false,null)


func _on_attack_timer_timeout() -> void:
	gobattackRdy = true 


func _on_timer_detect_struc_timeout() -> void:
	if check_if_gob_still_near != 0:
		check_if_gob_still_near += -1
	if $Area2DfindStructure/CollisionShape2D.disabled == true:
		$Area2DfindStructure/CollisionShape2D.disabled = false
	else:
		$Area2DfindStructure/CollisionShape2D.disabled = true
