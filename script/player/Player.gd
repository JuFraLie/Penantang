extends CharacterBody2D

@export var max_health: int = 100

var is_invincible: bool = false
var facing_direction: Vector2 = Vector2.DOWN
var health: int

@onready var hitbox: Area2D = $Hitbox
@onready var visual: ColorRect = $TempVisual

var original_color: Color

func _ready() -> void:
	health = max_health
	hitbox.monitoring = false
	original_color = visual.color

func take_damage(amount: int) -> void:
	health -= amount
	_flash()

func _flash() -> void:
	visual.color = Color.WHITE
	await get_tree().create_timer(0.1).timeout
	visual.color = original_color
