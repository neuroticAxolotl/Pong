extends KinematicBody2D

var velocity = 220

var ball_instance_id = null # updated by main (Pong.gd)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if ball_instance_id != null:
		var ball = instance_from_id(ball_instance_id)
		if ball != null:
			if ball.position.y < position.y-10:
				move_and_slide(Vector2.UP * velocity)
			elif ball.position.y > position.y+10:
				move_and_slide(Vector2.DOWN * velocity)

	
	# completely disable sideways movement
	position.x = 874
	# 150 for left paddle, 874 for right

