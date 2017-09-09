extends StaticBody2D

onready var camera = get_node("Camera2D")
onready var platform = get_children()[0]

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
func _fixed_process(delta):
	if (camera.get_zoom() > Vector2(0.4, 0.4)):	
		camera.set_zoom(camera.get_zoom() - Vector2(0.03, 0.03))
	if (get_node("Bear1") == null):
		get_tree().change_scene("res://endscreen.tscn")



func _on_Area2D1_body_enter( body ):
	if (body.is_in_group("player") && get_node("Bear1") != null):
		camera.make_current()
		get_node("Bear1").wake_up(body)
		set_fixed_process(true)


func _on_Area2D1_body_exit( body ):
	if (body.is_in_group("player")):
		
		get_parent().get_parent().get_node("Player/Camera2D").make_current()
		if (get_node("Bear1") != null):
			get_node("Bear1").sleep()
		set_fixed_process(false)
