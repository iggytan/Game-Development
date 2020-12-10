extends Node2D

onready var raindrop_scene = preload("res://RainDrop0.tscn")

const raindrop_count = 1360
const min_speed = 50
const speed_range = 100

var screen_size
var fps = 60.0 # Initial ideal value for running average
var frame_number = 0;

var sumDelta = 0
var maxProcessDelta = 0;
var nextMileStone = 5;


# Called when the node enters the scene tree for the first time.
func _ready():
	# Randomly distribute initial raindrops across the screen.
	screen_size = get_viewport().size
	for i in range(raindrop_count/5):
		spawn_raindrop(int(screen_size.x), int(screen_size.y))
	pass 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	frame_number = frame_number + 1
	sumDelta = sumDelta + delta
	#processCount = processCount + 1
	
	# Skip tracking first second, as scene loading is usually slow.
	if (sumDelta > 1.0):
		if (delta > maxProcessDelta):
			maxProcessDelta = delta
	
	# Average out the FPS with the previous FPS, in this case 90% of the old value, 10% of the current value.
	fps = (fps * 0.9) + (Engine.get_frames_per_second() * 0.1)
	
	# We decide what debug to output based on the current frame number.
	# 1. Output running average FPS every 20th frame.
	# 2. Output average FPS (calculated differently) and minimum FPS every 120 frames.
	# 3. Output the number of seconds every 5 seconds, so we know which lines to use for our logs to send to the lead developer.
	if (frame_number % 20 == 0):
		print('current FPS: ' + str(fps))
	if (frame_number % 120 == 0):
		print('avg FPS: ' + str(frame_number / sumDelta) + ', min FPS: ' + str(1.0/maxProcessDelta))
	if (sumDelta >= nextMileStone):
		print(str(nextMileStone) + ' seconds\r\n')
		nextMileStone = nextMileStone + 5
	pass


func _on_block_despawn():
	# Spawn a raindrop on the top line at a random horizontal position.
	spawn_raindrop(int(screen_size.x), 1)
	pass


# Spawn a raindrop within a given rectangular area with a random velocity.
func spawn_raindrop(range_x, range_y):
	var raindrop = raindrop_scene.instance()
	raindrop.position = Vector2(randi() % range_x, randi() % range_y)
	# Connect the despawn signal
	raindrop.connect("despawn", self, "_on_block_despawn")
	raindrop.set_velocity((randi() % speed_range) + min_speed)
	self.add_child(raindrop)
