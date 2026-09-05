extends Area2D

@export var damage: int = 10

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("boss_hurtbox"):
		if area.has_method("take_damage"):
			area.take_damage(damage)
