extends CharacterBody3D

@export var speed := 5.0
@export var jump_velocity := 4.5
@export var mouse_sensitivity := 0.002

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var rotation_x := 0.0

@onready var camera = $Camera3D


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	add_to_group("Player")

func _input(event):
	if event is InputEventMouseMotion:
		# Horizontal rotation (player body)
		rotate_y(-event.relative.x * mouse_sensitivity)

		# Vertical rotation (camera)
		rotation_x -= event.relative.y * mouse_sensitivity
		rotation_x = clamp(rotation_x, -1.5, 1.5)
		camera.rotation.x = rotation_x


func _physics_process(delta):
	# Gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	# Movement input
	var input_dir := Input.get_vector(
		"move_left",
		"move_right",
		"move_forward",
		"move_back"
	)

	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()
