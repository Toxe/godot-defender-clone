extends Area2D

func setup(spawn_position: Vector2):
    global_position = spawn_position
    $MovementComponent.direction = Vector2.RIGHT.rotated(randf_range(0.0, 2 * PI))


func _on_area_entered(_area):
    queue_free()


# automatically destroy when off-screen
func _on_visible_on_screen_notifier_2d_screen_exited():
    queue_free()
