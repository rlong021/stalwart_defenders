extends Area2D

@export var speed = 400
@export var Damage:int
@export var direction:Vector2

func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += direction * delta * speed

func _on_die_timer_timeout() -> void:
	blow_up()

func _on_area_entered(area: Area2D) -> void:
	blow_up()

func blow_up():
	hide()
	queue_free()
