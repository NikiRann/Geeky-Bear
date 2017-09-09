extends StaticBody2D

onready var camera = get_node("Camera2D")
onready var platform = get_children()[0]

func _fixed_process(delta):
	if (camera.get_zoom() > Vector2(0.4, 0.4)):	
		camera.set_zoom(camera.get_zoom() - Vector2(0.03, 0.03))
	if (get_node("Bear1") == null):
		#print (get_children())
		if (platform.get_pos().y < get_node("Position2D").get_pos().y):
			platform.translate(Vector2(0,5))
		else:
			set_fixed_process(false)
			



func _on_Area2D_body_enter( body ):
	if (body.is_in_group("player") && get_node("Bear1") != null):
		camera.make_current()
		get_node("Bear1").wake_up(body)
		set_fixed_process(true)


func _on_Area2D_body_exit( body ):
	if (body.is_in_group("player")):
		get_parent().get_parent().get_node("Player/Camera2D").make_current()
		if (get_node("Bear1") != null):
			get_node("Bear1").sleep()
		set_fixed_process(false)


func _on_Area2D1_body_enter( body ):
	pass # replace with function body
