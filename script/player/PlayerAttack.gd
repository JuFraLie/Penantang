extends State

@export var attack_duration: float = 0.3
@export var attack_cooldown: float = 0.2

@onready var player: CharacterBody2D = owner
@onready var hitbox: Area2D = player.get_node("Hitbox")

var timer: float = 0.0
var can_attack: bool = true

func can_enter() -> bool:
	return can_attack

func enter() -> void:
	print("Player entered Attack state")
	timer = attack_duration
	can_attack = false
	player.velocity = Vector2.ZERO
	hitbox.position = player.facing_direction.normalized() * 50
	hitbox.monitoring = true

func exit() -> void:
	print("Attack exit - monitoring OFF")
	hitbox.monitoring = false
	var cooldown_timer := get_tree().create_timer(attack_cooldown)
	cooldown_timer.timeout.connect(func(): can_attack = true)

func physics_update(delta: float) -> void:
	timer -= delta
	if timer <= 0:
		transitioned.emit("Idle")
