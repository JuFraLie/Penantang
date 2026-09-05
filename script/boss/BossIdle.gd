extends State

@export var detection_range: float = 300.0

@onready var boss: CharacterBody2D = owner
var player: Node2D

func enter() -> void:
	boss.velocity = Vector2.ZERO
	player = get_tree().get_first_node_in_group("player")

func physics_update(_delta: float) -> void:
	if player and boss.global_position.distance_to(player.global_position) <= detection_range:
		transitioned.emit("Chase")
