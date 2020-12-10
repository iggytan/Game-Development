extends KinematicBody2D

const MOVE_SPEED = 50

var velocity = Vector2.ZERO

var player = null # a reference to the player so we can move relative to them

func _ready():
	add_to_group("enemies") # add this Node to the enemies group

func _physics_process(delta):
	 velocity = Vector2.ZERO
	 if player:
			velocity = position.direction_to(player.position) * MOVE_SPEED
			velocity = move_and_slide(velocity)
			

func _on_DetectRadius_body_entered(body):
	player = body

func _on_DetectRadius_body_exited(body):
	player = null
	
func set_player(p):
	player = p
