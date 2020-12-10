extends KinematicBody2D

const MOVE_SPEED = 50

var velocity = Vector2.ZERO

var player = null # a reference to the player so we can move relative to them

var enemiesposition=Vector2()

func _ready():
	add_to_group("enemies") # add this Node to the enemies group 

func get_furthest_enemy(): # to find the furthest enemy
	var max_dist = 99999
	var max_enemy
	var enemies = get_tree().get_nodes_in_group("enemies")
	for enemy in enemies:
		var dist = $Player.position.distance_to(enemy.position)
		if (dist > max_dist):
			max_dist = dist
			max_enemy = enemy
	return max_enemy
	print(max_enemy)
	
func _physics_process(delta):
	 velocity = Vector2.ZERO # Using the Vector to locate player
	 if player:
			velocity = position.direction_to(player.position) * MOVE_SPEED
			velocity = move_and_slide(velocity)
	 
#If Enemy 1 position less than Enemy 2 or 3 then Enemy 1 to follow player
#If Enemy 2 position less than Enemy 1 or 3 then Enemy 2 to follow player
#If Enemy 3 position less than Enemy 1 or 2 then Enemy 3 to follow player

func _on_DetectRadius_body_entered(body): # This relates to the follow on/off question
	player = body                         # When the player is within the radius it follows

func _on_DetectRadius_body_exited(body): # When the player is outside the radius it stops following
	player = null
	
func set_player(p):
	player = p
