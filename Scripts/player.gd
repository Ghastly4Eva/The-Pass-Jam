extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

enum GravityOrientation {Down, Up}
var CurrentGravity = GravityOrientation.Down

@export var sensitivity = 0.003
@onready var camera: Camera3D = $Camera3D
@onready var animation_player: AnimationPlayer = $Camera3D/AnimationPlayer

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if CurrentGravity == GravityOrientation.Down:
			rotate_y(-event.relative.x * sensitivity)
			camera.rotate_x(-event.relative.y * sensitivity)
		elif CurrentGravity == GravityOrientation.Up:
			rotate_y(event.relative.x * sensitivity)
			camera.rotate_x(event.relative.y * sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(70))

func _process(delta):
	if Input.is_action_just_pressed("escape"):
		get_tree().quit()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if CurrentGravity == GravityOrientation.Down:
		up_direction = Vector3.UP
		velocity += get_gravity() * delta
	elif CurrentGravity == GravityOrientation.Up:
		up_direction = Vector3.DOWN
		velocity += get_gravity() * -delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		if CurrentGravity == GravityOrientation.Down:
			velocity.y = JUMP_VELOCITY
		elif CurrentGravity == GravityOrientation.Up:
			velocity.y = -JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if CurrentGravity == GravityOrientation.Up:
		direction = (transform.basis * Vector3(input_dir.x, 0, -input_dir.y)).normalized()
	
	if direction:
		if CurrentGravity == GravityOrientation.Down:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = direction.x * -SPEED
			velocity.z = direction.z * -SPEED
	else:
		if CurrentGravity == GravityOrientation.Down:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
			
	move_and_slide()
