extends KinematicBody2D


var velocity = 200
var direction = Vector2(0,0)

var is_ball = true # checked by Goal.gd

signal ball_collided # for audio

onready var particle_emitter = get_node("CPUParticles2D")

var x_list = []

# Called when the node enters the scene tree for the first time.
func _ready():
	particle_emitter.emitting = false
	
	# how many frames the ball has to be still to be considered stuck
	for _i in range(5):
		x_list.append(0)


func _physics_process(delta):
	var collision = move_and_collide(direction.normalized()*velocity*delta)
	
	if collision:
		particle_emitter.restart()
		direction = direction.bounce(collision.normal)
		direction += collision.collider_velocity.normalized()
		emit_signal("ball_collided")
		
		if collision.collider.name in ["Left_Paddle","Right_Paddle"]:
			velocity += 50
	
	
	# disable collider if ball gets stuck
	# checks if x position has changed at all in 5 frames
	
	var same_x_count = 0
	
	for x in x_list:
		if x == position.x:
			same_x_count += 1
		else:
			break
	
	if same_x_count >= 5:
		$CollisionShape2D.disabled = true
		yield(get_tree().create_timer(0.5), "timeout")
		$CollisionShape2D.disabled = false
	
	x_list.push_back(position.x)
	x_list.pop_front()
