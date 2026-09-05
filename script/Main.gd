extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var boss: CharacterBody2D = $Boss
@onready var player_bar: ProgressBar = $UI/PlayerHealthBar
@onready var boss_bar: ProgressBar = $UI/BossHealthBar
@onready var result_label: Label = $UI/ResultLabel
@onready var camera: Camera2D = $Camera2D

var game_over: bool = false
var last_player_health: int
var last_boss_health: int

func _ready() -> void:
	player_bar.max_value = player.max_health
	boss_bar.max_value = boss.max_health
	last_player_health = player.health
	last_boss_health = boss.health

func _process(_delta: float) -> void:
	if game_over:
		return
	if is_instance_valid(player):
		player_bar.value = player.health
		if player.health < last_player_health:
			_shake()
		last_player_health = player.health
	if is_instance_valid(boss):
		boss_bar.value = boss.health
		if boss.health < last_boss_health:
			_shake()
		last_boss_health = boss.health
	else:
		_end_game("You win!")
	if is_instance_valid(player) and player.health <= 0:
		_end_game("You died")

func _shake() -> void:
	var original_pos := camera.position
	var tween := create_tween()
	tween.tween_property(camera, "position", original_pos + Vector2(8, 0), 0.03)
	tween.tween_property(camera, "position", original_pos - Vector2(8, 0), 0.03)
	tween.tween_property(camera, "position", original_pos, 0.03)

func _end_game(text: String) -> void:
	game_over = true
	result_label.text = text
	result_label.visible = true
	get_tree().paused = true
