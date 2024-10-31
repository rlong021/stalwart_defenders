extends Control

var TAH:int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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
	
