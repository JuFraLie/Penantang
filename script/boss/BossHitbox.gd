extends Area2D

@export var damage: int = 15

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	print("Boss hitbox detected: ", area.name, " in groups: ", area.get_groups())
	if area.is_in_group("player_hurtbox"):
		if area.has_method("take_damage"):
			area.take_damage(damage)
