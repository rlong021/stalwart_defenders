extends Control

signal Current_Hero
signal goblinsLeft

@export var gob_scene: PackedScene
var TAH:int
var gob_speed
var starting_gob_to_kill
var goblins_to_kill
var goblins_spawned

func _ready() -> void:
	get_tree().paused = true
	

func _process(delta: float) -> void:
	if $TileMapLayer2.tilearray.max() == 0:
		lost_game()
	if goblins_to_kill == 0:
		win_game()
	goblinsLeft.emit(goblins_to_kill)

func _input(event):
	if event.is_action_pressed("toggle_down"):
		TAH = (TAH+1)%3
		toggle_active_hero()
	elif event.is_action_pressed("toggle_up"):
		TAH = (TAH+2)%3
		toggle_active_hero()
	Current_Hero.emit(TAH)
		
func toggle_active_hero():
	if TAH == 0:
		$fighter.change_state("active")
		$archer.change_state("passive")
		$mage.change_state("passive")
	elif TAH == 1:
		$fighter.change_state("passive")
		$archer.change_state("active")
		$mage.change_state("passive")
	else:
		$fighter.change_state("passive")
		$archer.change_state("passive")
		$mage.change_state("active")
	


func _on_timer_goblin_spawn_timeout() -> void:
	goblins_spawned += 1
	if goblins_spawned <= starting_gob_to_kill:
		var gob = gob_scene.instantiate()
		var gob_spawn_location = $GoblinSpawnPath2D/GoblinSpawnPathFollow2D
		gob_spawn_location.progress_ratio = randf()
		var direction = gob_spawn_location.rotation + PI
		gob.position = gob_spawn_location.position
		#gob.rotation = direction
		var velocity = Vector2(0, 1)
		gob.SPEED = gob_speed
		gob.velocity = velocity
		add_child(gob)
	elif goblins_spawned >= starting_gob_to_kill:
		$TimerGoblinSpawn.stop()

func _on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	pass # Replace with function body.

func lost_game():
	$EndGameLostLabel.visible = true
	get_tree().paused = true
	$QuitMenu.visible = true
	
func win_game():
	$EndGameWinLabel.visible = true
	get_tree().paused = true
	$QuitMenu.visible = true

func start_game(GSpawn, GSpeed, SpawnRate):
	get_tree()
	starting_gob_to_kill = GSpawn
	goblins_to_kill = starting_gob_to_kill
	goblins_spawned = 0
	gob_speed = GSpeed
	$fighter.position = Vector2(300,215)
	$archer.position = Vector2(490,215)
	$mage.position = Vector2(105,215)
	$FighterFlag.position = $fighter.position
	$ArcherFlag.position = $archer.position
	$MageFlag.position = $mage.position
	$TimerGoblinSpawn.wait_time = SpawnRate
	TAH = 0
	toggle_active_hero()
	Current_Hero.emit(TAH)
	get_tree().paused = false


func _on_easy_button_pressed() -> void:
	start_game(75, 1,1.1)
	$GridContainer/EasyButton.visible = false
	$GridContainer/NormalButton.visible = false
	$GridContainer/HardButton.visible = false
	$GridContainer/BackButton.visible = false

func _on_normal_button_pressed() -> void:
	start_game(100, 2,1)
	$GridContainer/EasyButton.visible = false
	$GridContainer/NormalButton.visible = false
	$GridContainer/HardButton.visible = false
	$GridContainer/BackButton.visible = false

func _on_hard_button_pressed() -> void:
	start_game(125, 3,.9)
	$GridContainer/EasyButton.visible = false
	$GridContainer/NormalButton.visible = false
	$GridContainer/HardButton.visible = false
	$GridContainer/BackButton.visible = false

func _on_q_button_pressed() -> void:
	get_tree().quit()

func _on_ng_button_pressed() -> void:
	$GridContainer/NGButton.visible = false
	$GridContainer/QButton.visible = false
	$GridContainer/EasyButton.visible = true
	$GridContainer/NormalButton.visible = true
	$GridContainer/HardButton.visible = true
	$GridContainer/BackButton.visible = true


func _on_back_button_pressed() -> void:
	$GridContainer/NGButton.visible = true
	$GridContainer/QButton.visible = true
	$GridContainer/EasyButton.visible = false
	$GridContainer/NormalButton.visible = false
	$GridContainer/HardButton.visible = false
	$GridContainer/BackButton.visible = false
	
func _on_quit_menu_pressed() -> void:
	get_tree().quit()
