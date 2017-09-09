extends KinematicBody2D

var GRAVITY = 600
const WALK_SPEED = 150
const CAN_JUMP_TIME_LIMIT = 0.3
const JUMP_STRENGTH = 350
var jumping = false
var jump_allowed_timer = 0

var damage = 11
var health = 100
var attacking = false
var sudjuci = 0

export (int) var smoothness = 0.1
var velocity = Vector2()

onready var anim = get_node("AnimatedSprite")
onready var attackraycast = get_node("attackcast")
onready var startpoint = get_parent().get_node("StartPos")

func _ready():
	set_pos(startpoint.get_pos())
	set_fixed_process(true)

func _fixed_process(delta):
	if (anim.get_animation() == "attack"):
		if (anim.get_frame() == 7):
			attacking = false
			anim.set_frame(0)
			anim.stop()
	else:
		attacking = false
	movement(delta)	
	if (Input.is_action_pressed("attack") && !attacking):
		attack()
	get_parent().get_node("CanvasLayer/Health").set_text("Health: " + str(health))
	get_parent().get_node("CanvasLayer/Sudjuci").set_text("Sudjuci: " + str(sudjuci))
	

func increase_damage(var value):
	sudjuci += 1
	damage += value 
	
	
func increase_jumppower(var value):
	GRAVITY -= value 

func heal(var value):
	if (health < 100):
		health += value

func apply_damage(var damage):
	health -= damage
	if (health <= 0):
		die()

func attack():
	attacking = true
		
	if (attackraycast.is_colliding()):
		
		if (attackraycast.get_collider().is_in_group("bears")):
			
			attackraycast.get_collider().do_damage(damage)
	anim.play("attack")
	 


func movement(delta):

		velocity.y += delta * GRAVITY
		var walking = false
		
		if (jump_allowed_timer > 0):
			jump_allowed_timer -= delta
		
		if (Input.is_action_pressed("ui_left")):
			velocity.x = - WALK_SPEED
			walking = true
			attackraycast.set_rotd(-90)
			anim.set_flip_h(true)
		elif (Input.is_action_pressed("ui_right")):
			walking = true
			anim.set_flip_h(false)
			attackraycast.set_rotd(90)
			velocity.x =   WALK_SPEED
		else:
			walking = false
			velocity.x = 0
		if (walking && !jumping && !attacking):
			anim.play("walking")
		else:
			if (!jumping && !attacking):	
				anim.set_frame(0)
				anim.stop()
		var motion = velocity * delta
		motion = move(motion)
		
		if (is_colliding()):
			if (get_collider().is_in_group("spikes")):
				die()
			if (jumping):
				anim.play("walking")
				anim.stop()
				anim.set_frame(0)
				jumping = false
			var n = get_collision_normal()		
			motion = n.slide(motion)
			velocity = n.slide(velocity)
			move(motion)
			if (Input.is_action_pressed("ui_up") && is_jump_allowed()):
				jumping = true
				anim.play("jump")
				velocity.y -= JUMP_STRENGTH
				jump_allowed_timer = CAN_JUMP_TIME_LIMIT
				
				
				
func is_jump_allowed():
	return (jump_allowed_timer <= 0) 

func die():
	get_tree().change_scene("res://deadscreen.tscn")


