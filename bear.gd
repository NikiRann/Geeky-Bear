extends KinematicBody2D

var velocity = Vector2()


const WALK_SPEED = 100
const GRAVITY = 550

export (int) var health = 100
export (int) var damage = 35
var hitting = false
var startedhit = false


onready var animation = get_node("AnimatedSprite")
onready var raycast = get_node("RayCast2D")
onready var headcast = get_node("RayCast2D 2")

var dead = false;
var enemy

func do_damage(var value):
	health -= value
	if (health <= 0):
		die()


func _ready():
	animation.play("default")
	
func wake_up(var body):
	enemy = body
	set_fixed_process(true)

func sleep():
	if (dead):
		queue_free()
	set_fixed_process(false)
	animation.play("default")
	
func _fixed_process(delta):
	if (dead):
		set_fixed_process(false)
	
	if (raycast.is_colliding()):
		var colider = raycast.get_collider()
		if (!colider.is_in_group("player")):
			movement(delta)
		else:
			if (!hitting):
				animation.stop()
				hitting = true
			else:
				animation.play("Hit")
				if (animation.get_frame() == 2):
					startedhit = false
					animation.set_frame(0)
				if (animation.get_frame() == 0 && !startedhit):
					colider.apply_damage(damage)
					startedhit = true
	elif(!headcast.is_colliding()):
		movement(delta)
	elif(headcast.is_colliding()):
		animation.play("default")
		animation.set_frame(0)
		animation.stop()


func movement(var delta):
	velocity.y += delta * GRAVITY
	var walking = false	
	if (enemy.get_pos().x < get_global_pos().x):
		velocity.x = - WALK_SPEED
		walking = true
		raycast.set_rotd(-90)
		animation.set_flip_h(true)
	elif (get_global_pos().x < enemy.get_pos().x):
		walking = true
	
		raycast.set_rotd(90)
		animation.set_flip_h(false)
		velocity.x =  WALK_SPEED
	else:
		walking = false
		velocity.x = 0
	if (walking):
		animation.play("Walk")
	
	var motion = velocity * delta
	
	motion = move(motion)
	if (is_colliding()):
		var n = get_collision_normal()
		motion = n.slide(motion)
		velocity = n.slide(velocity)
		move(motion)

func die():
	get_parent().get_parent().get_parent().get_node("Player/Camera2D").make_current()
	queue_free()