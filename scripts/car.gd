extends KinematicBody2D

var speed = 200
var rotation_speed = 5.0

var velocity = Vector2.ZERO
var rotation_dir = 0

func get_input():
	rotation_dir = 0
	velocity = Vector2.ZERO
	if Input.is_action_pressed("steer_right"):
		rotation_dir += 1
	if Input.is_action_pressed("steer_left"):
		rotation_dir -= 1
	if Input.is_action_pressed("brake"):
		velocity -= transform.x * speed
	if Input.is_action_pressed("accel"):
		velocity += transform.x * speed

func _physics_process(delta):
	get_input()
	rotation += rotation_dir * rotation_speed * delta
	velocity = move_and_slide(velocity)
