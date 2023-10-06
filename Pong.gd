extends Node2D

var left_points = 0
var right_points = 0
onready var left_points_display = get_node("Left_Points")
onready var right_points_display = get_node("Right_Points")

var ball_scene = preload("res://Ball.tscn")
var current_ball_id

onready var goals = [get_node("Left_Goal"), get_node("Right_Goal")]

onready var win_text = get_node("Win_Indicator")
var win_requirement = 5

onready var sound_player = get_node("Sound_Player")
onready var sounds = sound_player.get_children()
var global_volume = -20

onready var ai_paddle = get_node("Right_Paddle")


# Called when the node enters the scene tree for the first time.
func _ready():
	# make rng random
	randomize()
	
	for sound in sounds:
		sound.volume_db = global_volume
	
	# connect goal signals to point assignment function
	for goal in goals:
		goal.connect("ball_collided_with_goal", self, "_on_ball_in_goal")
	
	spawn_ball()


func spawn_ball():
	var ball = ball_scene.instance()
	
	var direction_x = -1 if (randi()%2) == 0 else 1 # randomly left or right
	var direction_y = rand_range(-0.5,0.5)
	
	ball.direction = Vector2(direction_x, direction_y)
	ball.position = Vector2(512, 300)
	
	current_ball_id = ball.get_instance_id()
	
	ai_paddle.ball_instance_id = current_ball_id
	
	ball.connect("ball_collided", self, "_on_ball_collided") # for audio
	
	self.call_deferred("add_child", ball)


func _on_ball_in_goal(side):
	# remove instead of reposition so the direction gets randomized again
	var ball = instance_from_id(current_ball_id)
	ball.queue_free()
	
	if side == "Left":
		right_points += 1
	
	if side == "Right":
		left_points += 1
	
	sound_player.get_node("Point").play()
	
	update_point_displays()


func _on_ball_collided():
	sound_player.get_node("Hit").play()


func update_point_displays():
	left_points_display.text = String(left_points)
	right_points_display.text = String(right_points)
	
	if left_points >= win_requirement or right_points >= win_requirement:
		win()
	else:
		spawn_ball()


func win():
	if left_points > right_points:
		win_text.rect_position = Vector2(175,200)
		win_text.text = "Left\nWins".c_unescape()
	else:
		win_text.rect_position = Vector2(540,200)
		win_text.text = "Right\nWins".c_unescape()
	
	sound_player.get_node("Win").play()
	
	# show winner for 3s before resetting
	win_text.visible = true
	yield(get_tree().create_timer(3.0), "timeout")
	win_text.visible = false
	
	left_points = 0
	right_points = 0
	
	update_point_displays()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var ball = instance_from_id(current_ball_id)
	if ball != null:
		if (ball.position.y <= -20
			or ball.position.y >= 620
			or ball.position.x <= -20
			or ball.position.x >= 1044):
				print_debug("Out of bounds")
				ball.queue_free()
				spawn_ball()
