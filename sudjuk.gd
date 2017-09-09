extends Node2D

onready var particles = get_node("Particles2D")
var dead = false

func _ready():
	set_fixed_process(true)
	
func _fixed_process(delta):
	if (dead):
		if (!particles.is_emitting()):
			queue_free()


func _on_Area2D_body_enter( body ):
	if (body.is_in_group("player")):	
		particles.set_emitting(true);
		body.increase_damage(6)
		body.increase_jumppower(10)
		body.heal(10)
		get_node("Area2D/Sprite").hide()
		dead = true
		
	
	#queue_free()
