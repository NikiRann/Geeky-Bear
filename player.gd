extends KinematicBody2D

const GRAVITY = 600
const WALK_SPEED = 150
const CAN_JUMP_TIME_LIMIT = 0.3
const JUMP_STRENGTH = 350


export (int) var smoothness = 0.1
var velocity = Vector2()

var jump_allowed_timer = 0


func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	movement(delta)

func movement(delta):

		velocity.y += delta * GRAVITY
		
		if (jump_allowed_timer > 0):
			jump_allowed_timer -= delta
		
		if (Input.is_action_pressed("ui_left")):
			velocity.x = - WALK_SPEED
			get_node("Sprite").set_flip_h(true)
		elif (Input.is_action_pressed("ui_right")):
			velocity.x =   WALK_SPEED
			get_node("Sprite").set_flip_h(false)
		else:
			velocity.x = 0
		
		var motion = velocity * delta
		motion = move(motion)
		
		if (is_colliding()):
			var n = get_collision_normal()
			motion = n.slide(motion)
			velocity = n.slide(velocity)
			move(motion)
			if (Input.is_action_pressed("ui_up") && is_jump_allowed()):
				velocity.y -= JUMP_STRENGTH
				jump_allowed_timer = CAN_JUMP_TIME_LIMIT
func is_jump_allowed():
	return (jump_allowed_timer <= 0) 




