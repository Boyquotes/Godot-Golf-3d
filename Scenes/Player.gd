extends KinematicBody

onready var camera = $Camera

var velocity = Vector3.ZERO
var gravity = 100.0
var turn_speed = 5.0
var fire_vector = Vector3(0, 1, -1).normalized()
var fire_force = 25.0
# 1.0 is no friction, 0.0 is infinite friction
var friction = .9

# find the vector perpendicular to a normalized vector on the x and z axis
func calculate_perpendicular_vector(normal):
	if normal.z == 0:
		return Vector3(0,0,1)
	
	return Vector3(1, 0, -normal.x/normal.z).normalized()


func _physics_process(delta):
	if Input.is_action_pressed("ui_left"):
		fire_vector = fire_vector.rotated(Vector3.UP, turn_speed * delta)
		#camera.rotate_y(turn_speed * delta)
	elif Input.is_action_pressed("ui_right"):
		fire_vector = fire_vector.rotated(Vector3.UP, -turn_speed * delta)
		#camera.rotate_y(-turn_speed * delta)
	
	# Get vector that is perpendicular to the fire_vector on the x and z axis
	var perpendicular_vector = calculate_perpendicular_vector(fire_vector)
	
	if Input.is_action_pressed("ui_up"):
		fire_vector = fire_vector.rotated(perpendicular_vector, turn_speed * delta)
	elif Input.is_action_pressed("ui_down"):
		fire_vector = fire_vector.rotated(perpendicular_vector, -turn_speed * delta)
	
	if Input.is_action_just_pressed("fire") and is_on_floor():
		velocity += fire_vector * fire_force
		
	camera.translation = Vector3(perpendicular_vector.x * -10, 3, abs(perpendicular_vector.z) * -10)
	camera.look_at(transform.origin, Vector3.UP)
	
	print(camera.translation)
	
	if is_on_floor():
		velocity.x *= friction
		velocity.z *= friction
	
	velocity.y -= gravity * delta
	velocity = move_and_slide(velocity, Vector3.UP)
	
	
