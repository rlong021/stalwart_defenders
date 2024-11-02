extends Control

@export var gob_scene: PackedScene
var TAH:int
var gob_speed = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$FighterFlag.position = $fighter.position
	TAH = 0
	toggle_active_hero()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _input(event):
	if event.is_action_pressed("toggle_hero"):
		TAH = (TAH+1)%3
		toggle_active_hero()
		
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
