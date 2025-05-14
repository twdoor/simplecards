extends CanvasLayer

func _unhandled_input(event):
	if event.is_action_pressed("ui_up"):
		add_child(Card.spawn_card())
