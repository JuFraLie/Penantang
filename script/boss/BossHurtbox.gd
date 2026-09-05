extends Area2D

func _ready() -> void:
	add_to_group("boss_hurtbox")

func take_damage(amount: int) -> void:
	owner.take_damage(amount)
