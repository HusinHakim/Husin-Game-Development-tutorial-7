extends CharacterBody3D

@export var speed: float = 10.0
@export var sprint_speed: float = 18.0
@export var crouch_speed: float = 4.0
@export var acceleration: float = 5.0
@export var gravity: float = 9.8
@export var jump_power: float = 5.0
@export var mouse_sensitivity: float = 0.3

@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D
@onready var torch_light: OmniLight3D = $Head/Camera3D/TorchLight

var camera_x_rotation: float = 0.0
var is_crouching: bool = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Inventory.inventory_changed.connect(_on_inventory_changed)
	torch_light.visible = false

func _on_inventory_changed():
	var item = Inventory.get_selected_item()
	if item and item.get("name") == "Torch":
		torch_light.visible = true
	else:
		torch_light.visible = false
		
func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		head.rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		var x_delta = event.relative.y * mouse_sensitivity
		camera_x_rotation = clamp(camera_x_rotation + x_delta, -90.0, 90.0)
		camera.rotation_degrees.x = -camera_x_rotation

func _physics_process(delta):
	# --- Crouch ---
	if Input.is_action_pressed("crouch"):
		is_crouching = true
		scale.y = lerp(scale.y, 0.5, 10 * delta)  # mengecilkan player
		head.position.y = lerp(head.position.y, 0.5, 10 * delta)
	else:
		is_crouching = false
		scale.y = lerp(scale.y, 1.0, 10 * delta)
		head.position.y = lerp(head.position.y, 1.0, 10 * delta)

	# --- Tentukan current speed ---
	var current_speed: float
	if is_crouching:
		current_speed = crouch_speed
	elif Input.is_action_pressed("sprint"):
		current_speed = sprint_speed
	else:
		current_speed = speed

	# --- Movement ---
	var movement_vector = Vector3.ZERO
	if Input.is_action_pressed("movement_forward"):
		movement_vector -= head.basis.z
	if Input.is_action_pressed("movement_backward"):
		movement_vector += head.basis.z
	if Input.is_action_pressed("movement_left"):
		movement_vector -= head.basis.x
	if Input.is_action_pressed("movement_right"):
		movement_vector += head.basis.x

	movement_vector = movement_vector.normalized()

	velocity.x = lerp(velocity.x, movement_vector.x * current_speed, acceleration * delta)
	velocity.z = lerp(velocity.z, movement_vector.z * current_speed, acceleration * delta)

	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_power

	move_and_slide()
