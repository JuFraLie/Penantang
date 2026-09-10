extends State

@onready var player: CharacterBody2D = owner
@onready var sprite: AnimatedSprite2D = player.get_node("AnimatedSprite2D")

func enter() -> void:
	player.velocity = Vector2.ZERO
	sprite.play("idle")

func physics_update(_delta: float) -> void:
	if Input.is_action_just_pressed("dodge"):
		transitioned.emit("Dodge")
		return
	if Input.is_action_just_pressed("attack"):
		transitioned.emit("Attack")
		return
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if input_dir != Vector2.ZERO:
		transitioned.emit("Move")
