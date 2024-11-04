extends Area2D

@export var Damage:int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Damage = $"..".BaseDamage


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
