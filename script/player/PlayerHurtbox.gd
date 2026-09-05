extends Area2D

@onready var player: CharacterBody2D = owner

func _ready() -> void:
	add_to_group("player_hurtbox")
	monitorable = true
	collision_layer = 1
	collision_mask = 1
	var shape_node := get_node("CollisionShape2D") as CollisionShape2D
	if not shape_node.shape:
		var new_shape := RectangleShape2D.new()
		new_shape.size = Vector2(32, 32)
		shape_node.shape = new_shape
	print("PlayerHurtbox ready — monitorable: ", monitorable, " shape: ", shape_node.shape)

func take_damage(amount: int) -> void:
	if player.is_invincible:
		return
	player.take_damage(amount)
