extends Area2D


export(String, "Left", "Right") var side = "Left"

signal ball_collided_with_goal(side)

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body):
	if body.get("is_ball"):
		emit_signal("ball_collided_with_goal", side)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

