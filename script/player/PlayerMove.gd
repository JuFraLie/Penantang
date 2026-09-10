extends State

@export var speed: float = 95.0 #ator depe kecepatan tarencana si klo lari 300

@onready var player: CharacterBody2D = owner
@onready var sprite: AnimatedSprite2D = player.get_node("AnimatedSprite2D")

func enter() -> void:
	sprite.play("walk")

func physics_update(_delta: float) -> void:
	if Input.is_action_just_pressed("dodge"):
		transitioned.emit("Dodge")
		return
	if Input.is_action_just_pressed("attack"):
		transitioned.emit("Attack")
		return
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if input_dir == Vector2.ZERO:
		transitioned.emit("Idle")
		return
	player.facing_direction = input_dir
	sprite.flip_h = input_dir.x < 0
	player.velocity = input_dir * speed
	player.move_and_slide()
