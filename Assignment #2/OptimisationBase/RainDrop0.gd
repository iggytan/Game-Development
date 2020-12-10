extends Node2D

# Setting up the visibility notifier so it deletes raindrops as they exit the screen
export (NodePath) var visibility_notifier_path
onready var visibility_notifier = get_node(visibility_notifier_path)

# Without freeing

var maxY = 1024
var speed
var speedSet = false
signal despawn

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var rigid = get_node('RigidBody2D')
	var o = rigid.get_global_transform_with_canvas()
	var y = o.get_origin().y
	#print(y)
	
	if (y > maxY):
		set_process(false)
		emit_signal("despawn")
		#queue_free()
	pass

func _physics_process(delta):
	if (!speedSet):
		var rigid = get_node('RigidBody2D')
		rigid.set_linear_velocity(Vector2(0, speed))
		speedSet = true
	pass

func set_velocity(speed):
	self.speed = speed
	self.speedSet = false

func _on_RainDrop_despawn():
	pass # Replace with function body.


func _on_VisibilityNotifier2D2_screen_exited(): # Removes the rain drops as they exit the screen - Proposed Changes #2
	queue_free()

