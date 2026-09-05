extends State

@export var telegraph_time: float = 0.3
@export var hit_active_time: float = 0.12
@export var gap_time: float = 0.15
@export var recovery_time: float = 0.4
@export var damage: int = 10
@export var hit_range: float = 60.0

@onready var boss: CharacterBody2D = owner
@onready var visual: ColorRect = boss.get_node("TempVisual")

var player: Node2D
var phase: String = "telegraph"
var timer: float = 0.0
var original_color: Color
var hits_done: int = 0
var has_hit_this_swing: bool = false

func enter() -> void:
	player = get_tree().get_first_node_in_group("player")
	boss.velocity = Vector2.ZERO
	phase = "telegraph"
	timer = telegraph_time
	hits_done = 0
	original_color = visual.color
	visual.color = Color.MAGENTA

func exit() -> void:
	visual.color = original_color

func physics_update(delta: float) -> void:
	timer -= delta
	match phase:
		"telegraph":
			if timer <= 0:
				phase = "active"
				timer = hit_active_time
				has_hit_this_swing = false
				visual.color = Color.RED
		"active":
			if not has_hit_this_swing and player:
				var dist := boss.global_position.distance_to(player.global_position)
				if dist <= hit_range:
					if player.has_method("take_damage") and not player.is_invincible:
						player.take_damage(damage)
					has_hit_this_swing = true
			if timer <= 0:
				hits_done += 1
				if hits_done >= 2:
					phase = "recovery"
					timer = recovery_time
					visual.color = original_color
				else:
					phase = "gap"
					timer = gap_time
					visual.color = Color.MAGENTA
		"gap":
			if timer <= 0:
				phase = "active"
				timer = hit_active_time
				has_hit_this_swing = false
				visual.color = Color.RED
		"recovery":
			if timer <= 0:
				transitioned.emit("Chase")
