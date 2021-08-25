extends KinematicBody

onready var camera = $Camera

export var gravity = 100.0
export(float, 0, 0.01) var turn_speed = .005
export var fire_force = 0
export(float, 0, 1) var friction = .99

signal force_changed

var velocity = Vector3.ZERO
var fire_vector = Vector3(0, 1, -1).normalized()
# 1.0 is no friction, 0.0 is infinite friction
var paused = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# find the vector perpendicular to a normalized vector on the x and z axis
func calculate_perpendicular_vector(normal):
	if normal.z == 0:
		return Vector3(0,0,1)
	
	return Vector3(1, 0, -normal.x/normal.z).normalized()


func _physics_process(delta):
	"""
	# OLD INPUT SYSTEM
	if Input.is_action_pressed("ui_left"):
		fire_vector = fire_vector.rotated(Vector3.UP, turn_speed)
		#camera.rotate_y(turn_speed * delta)
	elif Input.is_action_pressed("ui_right"):
		fire_vector = fire_vector.rotated(Vector3.UP, -turn_speed)
		#camera.rotate_y(-turn_speed * delta)
	
	# Get vector that is perpendicular to the fire_vector on the x and z axis
	var perpendicular_vector = calculate_perpendicular_vector(fire_vector)
	
	if Input.is_action_pressed("ui_up"):
		fire_vector = fire_vector.rotated(perpendicular_vector, turn_speed)
	elif Input.is_action_pressed("ui_down"):
		fire_vector = fire_vector.rotated(perpendicular_vector, -turn_speed)
	"""
	
	if Input.is_action_just_pressed("ui_cancel"):
		paused = !paused
		if paused:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if !paused:
		if is_on_floor():
			if Input.is_action_pressed("fire"):
				fire_force += 1
				emit_signal("force_changed", fire_force)
			if Input.is_action_just_released("fire"):
				velocity += fire_vector * fire_force
				fire_force = 0
				
		# 2d vector to position the camera while ignoring the y dimension of the fire_vector
		var look_vector = Vector2(fire_vector.x, fire_vector.z).normalized()
		camera.translation = Vector3(look_vector.x * -10, 3, look_vector.y * -10)
		camera.look_at(transform.origin, Vector3.UP)
		
		if is_on_floor():
			velocity.x = lerp(velocity.x, velocity.x * friction, .03)
			velocity.z = lerp(velocity.z, velocity.z * friction, .03)
		
		velocity.y -= gravity * delta
		velocity = move_and_slide(velocity, Vector3.UP)
	
	
func _input(event):
	if !paused:
		# If the player moves the mouse
		if event is InputEventMouseMotion:
			fire_vector = fire_vector.rotated(Vector3.UP, event.relative.x * -turn_speed)
			#fire_vector = fire_vector.rotated(calculate_perpendicular_vector(fire_vector), event.relative.y * turn_speed)
