extends Area2D


func setup(spawn_position: Vector2):
    global_position = spawn_position


func _on_area_entered(_area):
    queue_free()


# automatically destroy when off-screen
func _on_visible_on_screen_notifier_2d_screen_exited():
    queue_free()
