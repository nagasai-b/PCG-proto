extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var wheel_base = 60
var steering_angle = 30
var velocity = Vector2.ZERO
var steer_angle
var engine_power = 400
var acceleration = Vector2.ZERO
var friction = -0.9
var drag = -0.0015
var brake = -450
var max_speed_reverse = 250

# Called when the node enters the scene tree for the first time.

func _physics_process(delta):
	acceleration = Vector2.ZERO
	get_input()
	apply_friction()
	calculate_steering(delta)
	velocity += acceleration * delta
	velocity = move_and_slide(velocity)

func get_input():
	var turn = 0
	if Input.is_action_pressed("steer_right"):
		turn +=1 
	if Input.is_action_pressed("steer_left"):
		turn -= 1
	steer_angle = turn * steering_angle
	if Input.is_action_pressed("accel"):
		acceleration = transform.x * engine_power
	if Input.is_action_pressed("brake"):
		acceleration = transform.x * brake

func calculate_steering(delta):
	var rear_wheel = position - transform.x * wheel_base / 2.0
	var front_wheel = position + transform.x * wheel_base / 2.0
	rear_wheel += velocity * delta
	front_wheel += velocity.rotated(steer_angle) * delta
	var new_heading = (front_wheel - rear_wheel).normalized()
	var d = new_heading.dot(velocity.normalized())
	if d > 0:
		velocity = new_heading * velocity.length()
	if d < 0:
		velocity = -new_heading * min(velocity.length(), max_speed_reverse)
	rotation = new_heading.angle()

func apply_friction():
	if velocity.length() < 5:
		velocity = Vector2.ZERO
	var fric_force = velocity * friction
	var drag_force = velocity * velocity.length() * drag
	if velocity.length()<100:
		fric_force *=3
	acceleration += drag_force+fric_force
