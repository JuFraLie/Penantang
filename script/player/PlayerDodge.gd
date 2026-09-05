extends State

@export var dodge_speed: float = 500.0
@export var dodge_duration: float = 0.25
@export var dodge_cooldown: float = 0.5

@onready var player: CharacterBody2D = owner

var dodge_direction: Vector2 = Vector2.ZERO
var timer: float = 0.0
var can_dodge: bool = true

func can_enter() -> bool:
	return can_dodge

func enter() -> void:
	dodge_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if dodge_direction == Vector2.ZERO:
		dodge_direction = player.facing_direction
	timer = dodge_duration
	can_dodge = false
	player.is_invincible = true

func exit() -> void:
	player.is_invincible = false
	var cooldown_timer := get_tree().create_timer(dodge_cooldown)
	cooldown_timer.timeout.connect(func(): can_dodge = true)

func physics_update(delta: float) -> void:
	timer -= delta
	player.velocity = dodge_direction * dodge_speed
	player.move_and_slide()
	if timer <= 0:
		transitioned.emit("Idle")
