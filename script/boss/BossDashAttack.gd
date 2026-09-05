extends State

@export var telegraph_time: float = 0.4
@export var dash_speed: float = 600.0
@export var dash_duration: float = 0.25
@export var recovery_time: float = 0.5
@export var damage: int = 20
@export var hit_range: float = 50.0

@onready var boss: CharacterBody2D = owner
@onready var visual: ColorRect = boss.get_node("TempVisual")
@onready var dash_indicator: Line2D = boss.get_node("DashIndicator")

var player: Node2D
var phase: String = "telegraph"
var timer: float = 0.0
var original_color: Color
var dash_direction: Vector2 = Vector2.ZERO
var has_hit: bool = false

func enter() -> void:
	player = get_tree().get_first_node_in_group("player")
	boss.velocity = Vector2.ZERO
	phase = "telegraph"
	timer = telegraph_time - (0.15 * (boss.phase - 1))
	timer = max(timer, 0.1)
	original_color = visual.color
	visual.color = Color.ORANGE
	has_hit = false
	if player:
		dash_direction = boss.global_position.direction_to(player.global_position)
	dash_indicator.points = PackedVector2Array([Vector2.ZERO, dash_direction * 300])
	dash_indicator.visible = true

func exit() -> void:
	visual.color = original_color
	boss.velocity = Vector2.ZERO
	dash_indicator.visible = false

func physics_update(delta: float) -> void:
	timer -= delta
	match phase:
		"telegraph":
			if timer <= 0:
				phase = "dash"
				timer = dash_duration
				visual.color = Color.RED
		"dash":
			boss.velocity = dash_direction * dash_speed
			boss.move_and_slide()
			if not has_hit and player:
				var dist := boss.global_position.distance_to(player.global_position)
				if dist <= hit_range:
					if player.has_method("take_damage") and not player.is_invincible:
						player.take_damage(damage)
					has_hit = true
			if timer <= 0:
				phase = "recovery"
				timer = recovery_time
				boss.velocity = Vector2.ZERO
				visual.color = original_color
		"recovery":
			if timer <= 0:
				transitioned.emit("Chase")
