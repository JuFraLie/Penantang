extends State

@export var speed: float = 100.0
@export var attack_range: float = 60.0
@export var dash_trigger_range: float = 250.0
@export var dash_check_interval: float = 1.0

@onready var boss: CharacterBody2D = owner
var player: Node2D
var dash_check_timer: float = 0.0

func enter() -> void:
	player = get_tree().get_first_node_in_group("player")
	dash_check_timer = dash_check_interval

func physics_update(delta: float) -> void:
	if not player:
		transitioned.emit("Idle")
		return
	var dist := boss.global_position.distance_to(player.global_position)
	if dist <= attack_range:
		_choose_attack()
		return
	if boss.phase >= 2 and dist <= dash_trigger_range:
		dash_check_timer -= delta
		if dash_check_timer <= 0:
			dash_check_timer = dash_check_interval
			if randf() < 0.4:
				transitioned.emit("DashAttack")
				return
	var direction := boss.global_position.direction_to(player.global_position)
	boss.velocity = direction * speed * boss.speed_multiplier
	boss.move_and_slide()

func _choose_attack() -> void:
	if boss.phase >= 3:
		var roll := randf()
		if roll < 0.3:
			transitioned.emit("DashAttack")
		elif roll < 0.6:
			transitioned.emit("ComboAttack")
		else:
			transitioned.emit("Attack")
	elif boss.phase == 2 and randf() < 0.3:
		transitioned.emit("ComboAttack")
	else:
		transitioned.emit("Attack")
