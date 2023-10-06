extends KinematicBody2D


var velocity = 220

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if (Input.is_action_pressed("ui_up")):
		move_and_slide(Vector2.UP * velocity)
	
	if (Input.is_action_pressed("ui_down")):
		move_and_slide(Vector2.DOWN * velocity)
	
	# completely disable sideways movement
	position.x = 150
	# 150 for left paddle, 874 for right

