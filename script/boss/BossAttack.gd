extends State

@export var telegraph_time: float = 0.6
@export var active_time: float = 0.2
@export var recovery_time: float = 0.4
@export var damage: int = 15
@export var hit_range: float = 60.0

@onready var boss: CharacterBody2D = owner
@onready var visual: ColorRect = boss.get_node("TempVisual")

var player: Node2D
var phase: String = "telegraph"
var timer: float = 0.0
var original_color: Color
var has_hit: bool = false

func enter() -> void:
	player = get_tree().get_first_node_in_group("player")
	boss.velocity = Vector2.ZERO
	phase = "telegraph"
	timer = telegraph_time - (0.2 * (boss.phase - 1))
	timer = max(timer, 0.15)
	original_color = visual.color
	visual.color = Color.YELLOW
	has_hit = false

func exit() -> void:
	visual.color = original_color

func physics_update(delta: float) -> void:
	timer -= delta
	match phase:
		"telegraph":
			if timer <= 0:
				phase = "active"
				timer = active_time
				visual.color = Color.RED
		"active":
			if not has_hit and player:
				var dist := boss.global_position.distance_to(player.global_position)
				if dist <= hit_range:
					if player.has_method("take_damage") and not player.is_invincible:
						player.take_damage(damage)
					has_hit = true
			if timer <= 0:
				phase = "recovery"
				timer = recovery_time
				visual.color = original_color
		"recovery":
			if timer <= 0:
				transitioned.emit("Chase")
