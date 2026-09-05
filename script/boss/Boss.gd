extends CharacterBody2D

@export var max_health: int = 100
@export var speed_multiplier: float = 1.0
var health: int
var phase: int = 1

@onready var visual: ColorRect = $TempVisual
var original_color: Color
var base_color: Color = Color(0.6, 0.2, 0.6)

func _ready() -> void:
	health = max_health
	add_to_group("boss")
	visual.color = base_color
	original_color = base_color

func take_damage(amount: int) -> void:
	health -= amount
	_flash()
	if health <= max_health * 0.25 and phase < 3:
		phase = 3
		base_color = Color(0.7, 0.05, 0.05)
		original_color = base_color
		speed_multiplier = 1.6
	elif health <= max_health * 0.5 and phase < 2:
		phase = 2
		base_color = Color(0.8, 0.4, 0.0)
		original_color = base_color
		speed_multiplier = 1.3
	if health <= 0:
		queue_free()

func _flash() -> void:
	visual.color = Color.WHITE
	await get_tree().create_timer(0.15).timeout
	visual.color = original_color
