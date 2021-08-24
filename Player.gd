extends KinematicBody

var velocity = Vector3.ZERO
var gravity = 100

func _physics_process(delta):
	if Input.is_action_just_pressed("jump"):
		velocity.y = 10
	
	velocity.y -= gravity
	velocity = move_and_slide(velocity, Vector3.UP)
