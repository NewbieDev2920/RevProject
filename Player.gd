extends CharacterBody3D

var meleeDamage = 50
@onready var  melee_anim = $AnimationPlayer

const SPEED: float = 5.0
const JUMP_VELOCITY: float = 6
const SENSITIVITY: float = 0.009
const RUNNINGMULTIPLIER : float = 1.7

#bob Variables
const BOB_FREQ: float = 2.0
const BOB_AMP: float = 0.08
var t_bob = 0.0

@onready var hitbox = $Head/Camera3D/Hitbox
@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D
@onready var stateIndicator: RichTextLabel = $Head/Camera3D/CanvasLayer/StateIndicator

func applySpeed() -> float:
	if Input.is_action_pressed("sprint"):
		stateIndicator.text = "RUNNING"
		return SPEED * RUNNINGMULTIPLIER
	return SPEED;
		

func melee():
	if Input.is_action_just_pressed("fire"):
		if not melee_anim.is_playing():
			melee_anim.play("Attack")
			melee_anim.queue("Return")
		if melee_anim.current_animation == "Attack":
			for body in hitbox.get_overlapping_bodies():
				if body.is_in_group("Player"):
					body.health -= meleeDamage
			

func _enter_tree() -> void:
	set_multiplayer_authority(str(name).to_int())

func _unhandled_input(event: InputEvent) -> void:
	if not is_multiplayer_authority(): return
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY) 
		camera.rotation.x = clamp(camera.rotation.x, rad_to_deg(-40), deg_to_rad(60))

func _ready():
	if not is_multiplayer_authority(): return
	pass#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float) -> void:
	
	if not is_multiplayer_authority(): return
	melee()
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir : Vector2 = Input.get_vector("left", "right", "up", "down")
	var direction : Vector3 = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			stateIndicator.text = "WALKING"
			velocity.x = direction.x * applySpeed()
			velocity.z = direction.z * applySpeed()
		else:
			stateIndicator.text = "IDLE"
			velocity.x = lerp(velocity.x, direction.x * applySpeed(), delta * 7.0)
			velocity.z = lerp(velocity.z, direction.z * applySpeed(), delta * 7.0)
		
	else:
		velocity.x = lerp(velocity.x, direction.x * applySpeed(), delta * 3.0)
		velocity.z = lerp(velocity.z, direction.z * applySpeed(), delta * 3.0)
	#Head Bob
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	move_and_slide()
	
func _headbob(time):
	if not is_multiplayer_authority(): return
	var pos: Vector3 = Vector3.ZERO
	pos.y = BOB_AMP * sin( time * BOB_FREQ) 
	pos.x = BOB_AMP * sin(time* BOB_FREQ/2)
	return pos
